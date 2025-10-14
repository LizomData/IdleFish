// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { modulePlugin } from 'ohpm-fast-plugin';

export default {
  system: hapTasks,
  plugins: [modulePlugin('secondTransaction')]
}
