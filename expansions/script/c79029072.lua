--喀兰贸易·近卫干员-银灰
function c79029072.initial_effect(c)
   --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,6)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029072.efilter)
	e1:SetCondition(c79029072.imcon)
	c:RegisterEffect(e1)
	--hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c79029072.spcost)
	e2:SetTarget(c79029072.sptg)
	e2:SetOperation(c79029072.spop)
	c:RegisterEffect(e2)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7200041,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c79029072.addct)
	e4:SetCondition(c79029072.addcon)
	e4:SetOperation(c79029072.addc)
	c:RegisterEffect(e4)
	--cannot release
	local e5=e1:Clone()
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)	
end
function c79029072.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029072.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1099)
end
function c79029072.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1099,1)
	end
end
function c79029072.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029072.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetCounter(0x1099)>0
end
function c79029072.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1099,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1099,1,REASON_COST)
end
function c79029072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_HANDES,e:GetHandler(),1,0,0)
end
function c79029072.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT) 
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_HAND,1,1,nil)
	local tc=Duel.GetFirstTarget()
	Duel.ConfirmCards(1-tp,tc)
	local opt=e:GetLabel()
   if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
		if not c:IsRelateToEffect(e) then return end
	 Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	 c:AddCounter(0x1099,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
end
end



