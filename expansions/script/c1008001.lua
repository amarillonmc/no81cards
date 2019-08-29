--罪恶王冠 樱满集
function c1008001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--change target and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1008001,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c1008001.tgcon)
	e1:SetOperation(c1008001.tgop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1008001,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c1008001.sptg)
	e3:SetOperation(c1008001.spop)
	c:RegisterEffect(e3)
	--void
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1008001,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c1008001.target)
	e5:SetOperation(c1008001.activate)
	c:RegisterEffect(e5)
	--void back
	-- local e6=Effect.CreateEffect(c)
	-- e6:SetDescription(aux.Stringid(1008001,6))
	-- e6:SetType(EFFECT_TYPE_IGNITION)
	-- e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e6:SetRange(LOCATION_MZONE)
	-- e6:SetCountLimit(1)
	-- e6:SetTarget(c1008001.vbtg)
	-- e6:SetOperation(c1008001.vbop)
	-- c:RegisterEffect(e6)
end
function c1008001.tcfilter(c,tp)
	return c:IsCode(1008002) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup()
end
function c1008001.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end--rp==tp or 
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsExists(c1008001.tcfilter,1,nil,tp) then return false end
	local tc=g:GetFirst()
	while tc and not tc:GetCode()==1008002 do
		tc=g:GetNext()
	end
	if tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsLocation(LOCATION_MZONE) or not tc:GetCode()==1008002 then return false end
	e:SetLabelObject(tc)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetLabelObject():IsAbleToDeck()
end
function c1008001.dfilter(c)
	return c:IsDestructable() and not ((c:IsSetCard(0x320e) or c:IsSetCard(0x520e)) and c:IsFaceup())
end
function c1008001.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 or not Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)then return end
	local sg=Duel.GetMatchingGroup(c1008001.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg and sg:GetCount()>0 then
		ct=Duel.Destroy(sg,REASON_EFFECT)
		if c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c1008001.sfilter(c,e,tp)
	return c:IsSetCard(0x320e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(1008001)
end
function c1008001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1008001.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1008001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1008001.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function c1008001.vfilter(c,e,tp)
	return (c:IsCode(1008014) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1)
	or ((c:IsSetCard(0x320e)and c:GetCode()~=1008014) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) 
	and c:GetFlagEffect(10080011)==0 and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetCode()~=1008001
end
function c1008001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) (chkc:IsCode(1008014) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1)
	or ((chkc:IsSetCard(0x320e)and chkc:GetCode()~=1008014) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) 
	and chkc:GetFlagEffect(10080011)==0 and chkc:IsFaceup() and chkc:IsType(TYPE_MONSTER) and chkc:GetCode()~=1008001 end
	if chk==0 then return Duel.IsExistingTarget(c1008001.vfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c1008001.vfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1008001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if (tc:IsCode(1008014) and Duel.GetLocationCount(tp,LOCATION_MZONE)<2)
	or ((tc:IsSetCard(0x320e)and tc:GetCode()~=1008014) and Duel.GetLocationCount(tp,LOCATION_SZONE)<1) then return false end
	if tc:IsFaceup() then
		Duel.RaiseSingleEvent(tc,1008001,e,0,0,0,0)
	end
end
-- function c1008001.vbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- if chk==0 then return Duel.IsExistingTarget(c1008001.tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
	-- local g=Duel.SelectTarget(tp,c1008001.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
-- end
-- function c1008001.tgfilter2(c)
	-- return c:IsSetCard(0xf9) and c:IsFaceup() and not c:IsCode(1008001) and c:GetFlagEffect(10080011)~=0 and c:GetCardTargetCount()~=0
-- end
-- function c1008001.vbop(e,tp,eg,ep,ev,re,r,rp)
	-- local tc=Duel.GetFirstTarget()
	-- if tc:GetCardTargetCount()==0 then return false end
	-- if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetFlagEffect(10080011)~=0 then
		-- Duel.RaiseSingleEvent(tc,10080011,e,0,0,0,0)
		-- Duel.Destroy(tc:GetFirstCardTarget(),REASON_EFFECT)
	-- end
-- end