(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� EFY �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q�F���/�c��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�8Yɿ�Y���T��%I���P�wo{�{�l�\�Z��r�K���l��+�r�S�U�/��5��N�;�����q0Ew�~z-�=�h. (J҅�����<��8^���k��P|������E0��pʦ\�Fi�Fi�uH��=�E(�GH�G}�"̵�"]E|¿�>k�U�9ʐ�i�Sċ�/��G�/>�|�!e������Ć��D^�ZO�M`���h�� ���@EYF�]6�/L�&����(ŵ`��l�ZЦ
3!���S>�A���U��,r�4A�8�:VblRzw��xn��E���uVz:��)K����ԍp7��A*�D������8�uY����G�D�ˁ/ԵoߠSgEUx�k�����ֿ�Eӥ��;���0���+%�������ď<���8�T�h��K��ϋ�!K2_��[�/�|��y�vC��eMYJ|2�{[f���-�e�6���|��i� f\�hY�%����98��R<��甶�I�=o݈L,C*�v��v�:���,���5$g�H�9QW s��D�݆�p��~|w�z\��P��-ƣVύܝ�#H0D\�\9^���H0�Lޫ����Ď��L�4��x :t�sh�su�4���6�P�I308׹�`uS��F���c�{q ~�-]̅�4.��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��'�"�xy2��4��������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��&C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��f�߽2��/��l������(^�)� �?*j����S��P���������'����G�y��S��]��H��9Zr;ˇr$��B?b�K����P�I9�S�bqU0U�좬�~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+����)�a�P_�&N�&.�n��s����2�]���4���j�Z�b�� 4��[�.u��z��3w�V�J�Bx��К0
�-�G�H�-MSΌ�5 �$./�@���y����n2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:i=��E�F1�>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~����I���?J����g�������K���2P����_���=����1���?��D��e������?��W
���*����?�St��(Fxe���	p�d��CД�4�2��:F������8�^��w������(��"���+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��{�K��3����R�Q�������������j����{��������K���Q����T�_)x[�����{3��#�C��)���h��t��>����c����n�]���� ���&s�P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\,Х7(w�j��1<tO��1G�������t���stNnq���*�*�s����g�@[���`%N��;���g�m��I��(/�A���{�?-L{�d҄�NSD�>�1�?��h�������Np���Y�3�ei��@y��1�TpD	i'b$�#�����HȜ'pr�CZ�?�����g�� �����g��T�_
*����+��ϵެ�]��)�.��*�/�����?F�D��������+��s��w��C�Ƕ �%H�W.���I/�~�a04�|�!��� <g]�܂��@I�E�E��Y�fI���(��e����?�&���+���L���j�*�7�[c�`��Ǟ#���~����� ���P�;aw괒RCCrG�v��|�a�' �؍r��*mw;p{G��=1@<Z���&#���9���n7���ލ��?N=?�����(MT������^��,����������B�߾�L)\.�D��_
�+���/_V�˟ƋK%����8����Q������a�����?�j��|��gi�.�#s�&]ƦX
u1
�\�e1���X���,����,��h�QTʐ���?8r��T��|>.���"�?��%�a��bB��vK#�Ļ���Jw�4Q?_����Є/�u�]q��ϥ��
t��yԘ	��G�׌�8��C0�2�v;Dت�L�5Aut_$�=��z���n|���8�;�?����R�;��d�O�?�����>���T_-T�L�!�W�?� ��^��C)x-��}�������;b%�A�*�5��`����,��x����%���?c�~�0�߃��\�[7�ndD�o�ݰ偆�A�74��k�];�L(�|#�S:�X̋�t�v:#������mc�y[�ȵ�f��#<���39��&���k�͛#���L�-��%��f�f�����'�n��(F�|d�ψA��:�����9Z��5��nM]9�5��	+�����Bm���_�SI�;�!qk!̻��!@]�Hr��pY�n���a���&8L9��Ӽ��+.��Sh+��mg#���s�O	+g�O�� r��A 5Ý�i'�I�D��?�}z��Vu}�Ț�Ґ^<�G��������/�����oa�Sxe��M��������-Q��_�����$�*���K�������� ���5��͝dv�
9���D~���P�'������7��������9�=n�C�j
�����m��?�=H��ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ�Z>�iB���8��Х��cs �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����t���MU��෰��g�������������k�����2P��W�������F���,0���U��\.��������Q]�����+��������b������T��V
.��#l��0�D)ơH�p�g0�D|g4�iGp%2`}*�}�\së,0�ʐ�+�ߏ�~����>��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C����{����O��%q�_���?���-V���/�V��U
�~�Z�k�/�/��t;u��+T��6r��j������>�Ӆ��rl'��W��u�P7q�^#�ȕ�H&��3�r;M�e�/���jW5	p������U�o��v�����?=}0��u������z��_��b�F���Z�&�+����{Ԏ�]׮����nE0]��W��$����������|@�ڕS;��z�7���]y�!�ƋM�?�k���n_��-n�{���K?�Y�Q1+\���fP���V��9O�վ2�n�]4��� �~�UQ����7D�.��ߐ�ӟ[�}���F�+|;��������>�z��8N�����\;�BϾ��.:J�'ߺ�o^m-���DYrg��x�ӿ)Ɔ��w���_���I"}�����<<��>�����S��ݭ���M�v����緲�W￟��c��?m�\�{�����q:�.�o�~��q���8��8K]8��'�PY?Xn��v��>ф�D����8���K�n�>j������gd���0�X=��^��6)���7|�*��q$�C4dE��o��y�VGƷu���J�f�^WV�o��t���I��᭝��f	�-����B?}�'�X��o�jc]'�8\.��s�r(A.��.�/]׽t�H׭�N�m������u��n�i�NLPb��/Ac�&A#�DL����Q�(�@B�Q���m��g;���9.�}nrO����>��Ͽ����ٽ��Kz��t�<��|��J�4D�
�g�d��ERx6��v��F��L,u)���ønm��1�ѓ�5Y^�ޗ�t�[]�o���4+�cѥ� l�^ ��k@�>��g6�	9���	�B>�h���*K�����������pM4'�F��~� 4��23i�aX�����h�mf�f��xdɈ���麩k�v�X%�;��8�^=<�ߡ$A��Mf�#�m![H�)Z��O�KP/U�*ۑ���fqθ	G�胉�f��8���)��GBdV���q]�����7k��>���b�4d�:*�·*�%�C�n���h�,GS䃍��0�}��� mN�����L6��pz48���)�� ��w��#?��i>���:��b'�/*;T�Ӫ,��{0�����Tk5�.s�렖N�B�A7��SIG�x��~�����~�-�3z:��Ƌ��oFB�����]ѯ}��ߕ��^�
�qjM1�0��]� �,��>��k�㒻��e��1�3�t=l��3����E]䢹@٢F)�<(��v�f� �r�	�Z]�����L^�����smo_��먒�lAU8n�0��~�\��{�=8����'i�L~�I��2�1p^�c�N�qPo�4cosb�1��U~��k�\:>u�os�X����K���kQQ�or�v!�۵�9�eWg��ɩ|E���c�����G��+�G��|�M6���[u���Ǎ���~�A�����?�~���C��vb�����~��W;��T���Hխ?W5��)�Xdۋ��~?�ƶ�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*��sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I��9a�\/L�A��-��mf�7
�t��D�T��F�Hn��m�K��bg�Y��D?C�ݜ�����C�+��f�v�r/��|i����;]P�d�8̣X���'�9��-F�%��G��~��݂�0I��F���a�]��=L��~����юp�S��,>^$����YB�tv�W2��TQp�	�T����|��R^�+`XNU[BLHz.%5XHh[%U�)�͇���K�)Nz��R��C�\ڏ�=}�f��LX�	�
z�@��K티�M=u��6��D�����!\�kO͕�u��`�ck�tM�F�xP�*�'����&�e���G�~ee�h.O�B��j�Z�;J��0�m����D�!��$3�0i$]N�L�D�ɰX��'�9d�#<#;V0��x'�	���*�!VI�����.֊�x���|�&��4/^�@�0J��t}�3�r�t3��ۉx��R4���z��ǘȾ�h���>&eY�댲l�3����r)���TJÁߝhpp��$_�h��p�h8��mi�+�|+�Zb�
��b+-_�ʕ�A4���)�Ht^+JT�RU@�4�c�x�%��e����Re��<�+�ѴoHZ��ѭ+r���N$*g=�x�q�T���Z�yw�
�n!A�JFj~$�d��^��t�b	��U�[e�-R��e��,��%��z<C!�V�ˣ$���@HP� ACwR��fn��ya����^jX@�J�(o��ډa�\e�nu����@@N��,a1Y�b��E�@YIo�I�ҙ2� sʲGxFv��0�M�;�a|o�Uk}Z(�L�Y�W��K9o6�s�>t��7���#�}��rmB��<��g(F�I�-G�A��I;f?eq�>����>�j>��)��iN\SPkm^ՠ�@�֮�6�5�����g��_��L0>�.@]���<�Й�<�WNW���ʡ�ڸ\dۜh���N��\�����%r78C���9(%K5n ��n�9�Wڸ$�Nn�	n"F1�4��՚�UC�֦������-��e
�C��IM�dK�	�5[��y�f��X��琳?�n�iu�Y���U��^?a�\ 7
`��j���-������*��6Kf|bZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Fֿ�:�G���ס�֡���g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m��11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷Ne�:me��y'��@˽����ct�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹���X!��RHn�0��Ep���m6�jb�%d�j�kwT3Z��=�0%�>�h╊�k��v�~��k����BqI��[���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��N�i�D�c��@�'�ݻ���k�?/K�ǳ���'�ݗ�8��_������M}�ɯ�@���I�{q�T|'��ֵ+�_���=���t�Zڀξ������3_l�N��3NϿ^�ͯ�COB�S�5
�#�i����zs����M����6�Ӧ	�4��i�}�ŵ�v@ڦv��N��i�l���~�v�oy��A�\��g	#�0�M�M^�n[D�d<b��[��:�c��{ȟ�8�6EMx�y�[g��O���T�g`�m����#�.��r�^��f��Ӳ����V{Ό=-��`ϙ���6��0g��}�0�r�̹p�a�C��V�m����c$s���5p�蟝�d';��}����h�  