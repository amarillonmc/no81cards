--放逐天牢-混沌圣堂
VHisc_HDST=VHisc_HDST or {}

--------------------------search filed---------------------------------
function VHisc_HDST.fth(ec,cid)
	local cs=_G["c"..cid]
	local e0=Effect.CreateEffect(ec)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,cid)
	e0:SetCost(VHisc_HDST.thcost)
	e0:SetTarget(VHisc_HDST.thtg)
	e0:SetOperation(VHisc_HDST.thop)
	ec:RegisterEffect(e0)
end
function VHisc_HDST.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function VHisc_HDST.thfilter(c)
	return c:IsCode(33201450) and c:IsAbleToHand()
end
function VHisc_HDST.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(VHisc_HDST.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function VHisc_HDST.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectMatchingCard(tp,VHisc_HDST.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

-------------code check------------------
function VHisc_HDST.nck(c)
	return c.VHisc_hdst or (VHisc_HDST.global_check and VHisc_HDST.codeck(VHisc_STCN,c)) or c:GetFlagEffect(33201450)>0
end


-------------code table------------------
function VHisc_HDST.creattable()
	if not VHisc_HDST.global_check then
		VHisc_HDST.global_check=true
		VHisc_STCN={}
		VHisc_STCN[1]=0 
	end
end
function VHisc_HDST.codeck(tab,cc)
	local result=false
	for i,v in ipairs(tab) do
		if cc:GetOriginalCode()==v then
			result=true
		end
	end
	return result
end

--function VHisc_HDST.reset(e,tp,eg,ep,ev,re,r,rp)
--  VHisc_STCN={}
--  VHisc_STCN[1]=0
--end
--------------------------------------------------------------------
VHisc_HDST.creattable()
-------------------------card effect------------------------------

local m=33201450
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--add card name
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.acncon1)
	e4:SetOperation(cm.acnop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetCondition(cm.acncon2)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_FZONE)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCountLimit(2,m)
	e6:SetTarget(cm.sumtg)
	e6:SetOperation(cm.sumop)
	c:RegisterEffect(e6)
end
cm.VHisc_hdst=true

--e2e3
function cm.atkfilter(c)
	return VHisc_HDST.nck(c)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end

--e4 e5
function cm.acncon1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==1-tp then return false end
	local ec=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and VHisc_HDST.nck(ec)
end
function cm.acncon2(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local ec=re:GetHandler()
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsControler(1-tp) and tc:IsLocation(LOCATION_ONFIELD) and tc:IsFaceup() and VHisc_HDST.nck(ec)
end
function cm.acnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local code=tc:GetOriginalCode()
	if not VHisc_HDST.codeck(VHisc_STCN,tc) then
		VHisc_STCN[#VHisc_STCN+1]=code
		Duel.Hint(HINT_CARD,tp,33201450)
		local fg=Duel.GetMatchingGroup(cm.fgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,nil,code)
		for fc in aux.Next(fg) do
			if fc:GetFlagEffect(33201450)==0 then
				fc:RegisterFlagEffect(33201450,nil,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
			end
		end
	end
end
function cm.fgfilter(c,code)
	return c:GetOriginalCode()==code
end

--e6
function cm.sumfilter(c,e,tp)
	return VHisc_HDST.nck(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xyzfilter(c)
	return c:IsXyzSummonable(nil) and VHisc_HDST.nck(c)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local sg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end