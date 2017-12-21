exec > /tmp/${PROJECT_NAME}_archive.log 2>&1


FRAMEWORK_NAME="YOUR-FRAMEWORK-NAME"

cd ${SRCROOT}/Pods/${FRAMEWORK_NAME}/

echo "🚀backup ${SRCROOT}/Pods/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.framework"
if [ -f "${FRAMEWORK_NAME}.zip" ]
then
    unzip -o ${FRAMEWORK_NAME}.zip
else
    zip -r ${FRAMEWORK_NAME}.zip ./${FRAMEWORK_NAME}.framework
fi



# extract armv7/arm64
echo "🚀extracting armv7"
lipo ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME} -thin armv7 -output ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}armv7

echo "🚀extracting arm64"
lipo ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME} -thin arm64 -output ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}arm64
rm -rf ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}

echo "🚀making new framework"
lipo -create ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}armv7 ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}arm64 -output ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}
rm -rf ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}armv7
rm -rf ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}arm64

echo "🚀removing i386*/x86*"
rm -rf ${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/i386*
rm -rf ${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/x86*
