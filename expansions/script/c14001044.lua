--罔骸神 夜骸星
local m=14001044
local cm=_G["c"..m]
cm.named_with_Goned=1
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
xpcall(function() require("expansions/script/c14001041") end,function() require("script/c14001041") end)
function cm.initial_effect(c)
	--goeffects
	go.effect(c)
end
