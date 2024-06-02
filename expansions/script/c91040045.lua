--外道魔之妖狐
local m=91040045
local cm=c91040045
function c91040045.initial_effect(c)
aux.AddCodeList(c,35405755)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m*2)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)   
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ts=e:GetHandler():GetOwner()
	local tc=Duel.SelectMatchingCard(ts,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		 local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_CONTROL)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
		e2:SetCountLimit(1)
		e2:SetTarget(cm.cttg)
		e2:SetOperation(cm.ctop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTarget(cm.cttg2)
		e1:SetOperation(cm.ctpop2)
		tc:RegisterEffect(e1,true)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	 local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return  loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) 
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return  true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.ctfilter(c)
	return c:IsFaceup()  and c:IsControlerCanBeChanged()
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
end
function cm.spfilter(c)
	return aux.IsCodeListed(c,35405755) and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectMatchingCard(tp,cm.ctfilter,ts,LOCATION_MZONE,0,1,1,nil)  
	if tg:GetCount()>0 then  
		Duel.GetControl(tg,tp,PHASE_END,1)
	end
end
function cm.fit2(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(35405755)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
