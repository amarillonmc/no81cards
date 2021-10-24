--幻兽佣兵团 副团长-白猫
function c33200421.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33200421.hspcon)
	e1:SetValue(c33200421.hspval)
	e1:SetOperation(c33200421.hspop)
	c:RegisterEffect(e1)   
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200421,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200421.chtg)
	e2:SetCondition(c33200421.chcon)
	e2:SetOperation(c33200421.chop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c33200421.regop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,33200421)
	e4:SetCondition(c33200421.thcon)
	e4:SetTarget(c33200421.thtg)
	e4:SetOperation(c33200421.thop)
	c:RegisterEffect(e4)  
end

--e1
function c33200421.spfilter(c)
	return c:IsSetCard(0x329) and c:IsAbleToGraveAsCost()
end
function c33200421.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c33200421.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c33200421.cfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 and Duel.IsExistingMatchingCard(c33200421.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c33200421.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c33200421.cfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function c33200421.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33200421.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end

--e2
function c33200421.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x329)
end
function c33200421.rmfilter(c)
	return c:IsAbleToRemove()
end
function c33200421.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c33200421.chfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c33200421.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200421.rmfilter,rp,LOCATION_GRAVE,0,1,nil) end
end
function c33200421.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c33200421.repop)
end
function c33200421.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c33200421.rmfilter,tp,LOCATION_GRAVE,0,nil)
	if sg:GetCount()>0 then
		local rc=sg:RandomSelect(tp,1)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end

--e3
function c33200421.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(33200421,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c33200421.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33200421)>0
end
function c33200421.thfilter(c,e,tp)
	return c:IsAbleToHand() and c:IsSetCard(0xc329) and not c:IsCode(33200421)
end
function c33200421.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200421.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c33200421.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200421.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end