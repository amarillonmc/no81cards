muxu=muxu or {}
local cm=muxu
muxu.loaded_metatable_list={}
--
--c-code:1195103 当前回合发动的卡
--
--p-code:1195103 这个回合发动过效果
--
function muxu.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=muxu.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			muxu.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
--
function muxu.check_set(c,setcode,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=muxu.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
--
function muxu.check_set_Soul(c)  --灵曲
	return muxu.check_set(c,"Soul")
end
function muxu.check_set_Border(c)   --交界
	return muxu.check_set(c,"Border")
end
function muxu.check_set_Legend(c)   --秘谈
	return muxu.check_set(c,"Legend")
end
--
function muxu.check_set_Urban(c)			 --灵都
	return muxu.check_set(c,"Urban")
end
function muxu.check_fusion_set_Urban(c)
	if c:IsHasEffect(6205579) then return false end
	local codet={c:GetFusionCode()}
	for j,code in pairs(codet) do
		local mt=muxu.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_Urban") and v then return true end
			end
		end
	end
	return false
end
--
function muxu.check_set_Butterfly(c)		 --蝶舞
	return muxu.check_set(c,"Butterfly")
end
function muxu.check_set_Lines(c)			 --灵纹
	return muxu.check_set(c,"Lines")
end
function muxu.check_set_Hinbackc(c) --莱姆狐
	return muxu.check_set(c,"Hinbackc")
end
function muxu.check_set_Medicine(c) --梅蒂欣
	return muxu.check_set(c,"Medicine")
end
function muxu.check_set_Poison(c)   --毒符
	return muxu.check_set(c,"Poison")
end
function muxu.check_set_Materdim(c)
	return muxu.check_set(c,"Materdim")
end
--
function muxu.check_set_NozaLeah(c)
	return muxu.check_set(c,"NozaLeah")
end
function muxu.check_link_set_NozaLeah(c)
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=muxu.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_NozaLeah") and v then return true end
			end
		end
	end
	return false
end
--
--muxu_ih_KTatara 有「小伞」记述的卡
function muxu.check_set_Tatara(c)   --小伞
	return muxu.check_set(c,"Tatara")
end
function muxu.check_fusion_set_Tatara(c)
	if c:IsHasEffect(6205579) then return false end
	local codet={c:GetFusionCode()}
	for j,code in pairs(codet) do
		local mt=muxu.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_Tatara") and v then return true end
			end
		end
	end
	return false
end
function muxu.check_link_set_Tatara(c)
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=muxu.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_Tatara") and v then return true end
			end
		end
	end
	return false
end
--
function muxu.check_set_Umbrella(c)   --伞符
	return muxu.check_set(c,"Umbrella")
end
function muxu.check_set_Scenersh(c)   --景愿
	return muxu.check_set(c,"Scenersh")
end
--
--
if not muxu.chk then
	muxu.chk=true
	--1111050 EVENT_TO_DECK
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists((function(c)
			return c:GetFlagEffect(1111050)~=0 end),1,nil)
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local p=Duel.GetTurnPlayer()
		local tg=eg:Filter((function(c)
			return c:GetFlagEffect(1111050)~=0 end),nil)
		if tg:GetCount()<1 then return end
		local b1=tg:IsExists(Card.IsControler,1,nil,p)
		local b2=tg:IsExists(Card.IsControler,1,nil,1-p)
		if b1 then Duel.ShuffleDeck(p) end
		if b2 then Duel.ShuffleDeck(1-p) end
		local tc=tg:GetFirst()
		while tc do
			tc:ReverseInDeck()
			tc=tg:GetNext()
		end 
	end)
	Duel.RegisterEffect(e1,0)
	--TURN ACTIVITY
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFlagEffect(rp,1195103)<1 then
			Duel.RegisterFlagEffect(tp,1195103,RESET_PHASE+PHASE_END,0,1)
		end
	end)
	Duel.RegisterEffect(e2,0)
	--当前回合发动的卡
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local rc=re:GetHandler()
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
			rc:RegisterFlagEffect(1195103,RESET_EVENT+0x1fe0000,0,0,Duel.GetTurnCount())
		end
	end)
	Duel.RegisterEffect(e3,0)
--
end
--
