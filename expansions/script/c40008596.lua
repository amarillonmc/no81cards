--深层之愿-大杯
function c40008596.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c40008596.lcheck)
	--increase level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008596,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,40008596)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c40008596.spcost)
	e3:SetTarget(c40008596.sptg)
	e3:SetOperation(c40008596.spop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--recover
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008596,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetCondition(c40008596.atkcon)
	e6:SetTarget(c40008596.rectg)
	e6:SetOperation(c40008596.recop)
	c:RegisterEffect(e6)
end
function c40008596.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xdf1d) and g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c40008596.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c40008596.cfilter,1,c,e,tp,zone) end
	local g=Duel.SelectReleaseGroup(tp,c40008596.cfilter,1,1,c,e,tp,zone)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c40008596.spfilter(c,e,tp,code)
	return c:IsLevelAbove(5) and c:GetOriginalCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008596.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp)
		and chkc~=cc and c40008596.spfilter(chkc,e,tp,cc:GetOriginalCode()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40008596.spfilter,tp,LOCATION_DECK,0,1,1,cc,e,tp,cc:GetOriginalCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40008596.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) then
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_CANNOT_TRIGGER)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e1)
		end
	Duel.SpecialSummonComplete()
	end
end
function c40008596.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	if bit.band(r,REASON_EFFECT)~=0 then return rp==1-tp end
	return e:GetHandler():IsRelateToBattle()
end
function c40008596.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c40008596.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end