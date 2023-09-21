--八云御魂
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--add effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.aetg)
	e3:SetOperation(s.aeop)
	c:RegisterEffect(e3)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
s.codetable={65130363,OPCODE_ISCODE,OPCODE_NOT}
function s.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function s.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(s.sprfilter2,1,c,tp,c,sc,lv)
end
function s.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(s.sprfilter1,1,nil,tp,g,c)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,s.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,s.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function s.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(s.codetable))
	Duel.SetTargetParam(ac)
	--Duel.SetTargetParam(4392470)
	--Duel.SetTargetParam(65130366)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.aeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	table.insert(s.codetable,ac)
	table.insert(s.codetable,OPCODE_ISCODE)
	table.insert(s.codetable,OPCODE_NOT)
	table.insert(s.codetable,OPCODE_AND)
	if KOISHI_CHECK then
		local cm=_G["c"..ac]		
		local inie=cm.initial_effect
		function addinit(c)
			local adde=Effect.CreateEffect(c)
			adde:SetType(EFFECT_TYPE_FIELD)
			adde:SetCode(EFFECT_UPDATE_ATTACK)
			adde:SetRange(LOCATION_ONFIELD)
			adde:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			adde:SetTarget(aux.TargetBoolFunction(Card.IsCode,ac))
			adde:SetValue(function (e,c)
				return 500*math.max(1,e:GetHandler():GetFlagEffect(65130366))
			end)
			c:RegisterEffect(adde)
			if inie then inie(c) end
		end
		cm.initial_effect=addinit
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,ac)
		local reg=Card.RegisterEffect
		for tc in aux.Next(g) do
			local Type=Duel.ReadCard(tc,CARDDATA_TYPE)   
			if Type&TYPE_NORMAL~=0 then Type=Type-TYPE_NORMAL end
			tc:SetCardData(CARDDATA_TYPE,Type|TYPE_EFFECT)
			local mt=getmetatable(tc)
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			mt.initial_effect=addinit
			tc.initial_effect(tc)
		end
	else
		Debug.Message("需要koishi函数！")
	end
end