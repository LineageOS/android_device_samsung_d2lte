#
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

## (2) Also get non-open-source specific aspects if available
$(call inherit-product-if-exists, vendor/samsung/d2lte/d2lte-vendor.mk)

## overlays
DEVICE_PACKAGE_OVERLAYS += device/samsung/d2lte/overlay

## Common overlays for the non-d2s
ifneq ($(filter cm_apexqtmo cm_expressatt,$(TARGET_PRODUCT)),)
DEVICE_PACKAGE_OVERLAYS += device/samsung/d2lte/apexq-common/overlay
endif

# Boot animation and screen size

ifeq ($(filter cm_apexqtmo cm_expressatt,$(TARGET_PRODUCT)),)
# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=320
else
# These poor devices have smaller screens
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=240
endif

# Audio configuration
PRODUCT_COPY_FILES += \
        device/samsung/d2lte/audio/snd_soc_msm_2x:system/etc/snd_soc_msm/snd_soc_msm_2x \
        device/samsung/d2lte/audio/audio_policy.conf:system/etc/audio_policy.conf

# Wifi
PRODUCT_COPY_FILES += \
        device/samsung/d2lte/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
        device/samsung/d2lte/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

# Keymaps
PRODUCT_COPY_FILES += \
       device/samsung/d2lte/keylayout/fsa9485.kl:system/usr/keylayout/fsa9485.kl \
       device/samsung/d2lte/keylayout/msm8960-snd-card_Button_Jack.kl:system/usr/keylayout/msm8960-snd-card_Button_Jack.kl \
       device/samsung/d2lte/keylayout/sec_key.kl:system/usr/keylayout/sec_key.kl \
       device/samsung/d2lte/keylayout/sec_keys.kl:system/usr/keylayout/sec_keys.kl \
       device/samsung/d2lte/keylayout/sec_powerkey.kl:system/usr/keylayout/sec_powerkey.kl \
       device/samsung/d2lte/keylayout/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl \
       device/samsung/d2lte/keylayout/sii9234_rcp.kl:system/usr/keylayout/sii9234_rcp.kl

# Media profile
PRODUCT_COPY_FILES += \
       device/samsung/d2lte/media/media_profiles.xml:system/etc/media_profiles.xml

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    initlogo.rle \
    init.bt.rc \
    init.crda.sh \
    init.led.sh \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.target.rc \
    ueventd.qcom.rc

# GPS
PRODUCT_PACKAGES += \
    gps.msm8960

PRODUCT_COPY_FILES += \
    device/samsung/d2lte/gps/gps.conf:system/etc/gps.conf

# Torch
PRODUCT_PACKAGES += Torch

# Wifi
PRODUCT_PACKAGES += \
    libnetcmdiface \
    linville.key.pub.pem \
    regdbdump \
    regulatory.bin \
    crda \
    macloader

# Lights
PRODUCT_PACKAGES += lights.msm8960

# QRNGD
PRODUCT_PACKAGES += qrngd

ifneq ($(TARGET_PRODUCT),cm_apexqtmo)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.audio.fluence.mode=endfire \
    persist.audio.handset.mic=digital \
    ro.qc.sdk.audio.fluencetype=fluence
endif

# NFC Support
PRODUCT_PACKAGES += \
    libnfc \
    libnfc_jni \
    Nfc \
    Tag \
    com.android.nfc_extras

# NFCEE access control
ifeq ($(TARGET_BUILD_VARIANT),user)
    NFCEE_ACCESS_PATH := device/samsung/d2lte/nfc/nfcee_access.xml
else
    NFCEE_ACCESS_PATH := device/samsung/d2lte/nfc/nfcee_access_debug.xml
endif
PRODUCT_COPY_FILES += \
    $(NFCEE_ACCESS_PATH):system/etc/nfcee_access.xml

# common msm8960
$(call inherit-product, device/samsung/msm8960-common/msm8960.mk)

ifeq ($(filter cm_apexqtmo cm_expressatt,$(TARGET_PRODUCT)),)
    $(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
else
    $(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)
endif
