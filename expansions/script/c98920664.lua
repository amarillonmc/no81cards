--电子暗黑记忆体
function c98920664.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c98920664.spcost)
	e1:SetTarget(c98920664.sptg)
	e1:SetOperation(c98920664.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920664)
	e2:SetTarget(c98920664.thtg)
	e2:SetOperation(c98920664.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920664,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98930664)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c98920664.target)
	e3:SetOperation(c98920664.activate)
	c:RegisterEffect(e3)
end
function c98920664.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c98920664.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920664.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98920664.thfilter(c)
	return c:IsSetCard(0x93,0x94) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98920664.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920664.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920664.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920664.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920664.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x4093) and c:IsType(TYPE_FUSION)
end
function c98920664.filter2(c,check)
	return c:IsAbleToChangeControler()
end
function c98920664.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920664.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c98920664.filter2,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c98920664.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c98920664.filter2,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c98920664.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() then
		 if not Duel.Equip(tp,lc,tc,false) then return end
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_EQUIP_LIMIT)
		 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		 e1:SetLabelObject(tc)
		 e1:SetValue(c98920664.eqlimit)
		 lc:RegisterEffect(e1)
		 if tc:IsCode(18967507) or tc:IsCode(40418351) then	 
			local atk=lc:GetAttack()	  
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(atk)
			lc:RegisterEffect(e2)
		end
	end
end
function c98920664.eqlimit(e,c)
	return c==e:GetLabelObject()
end