--方舟骑士·破碎书页 真理
function c82567783.initial_effect(c)
	--Summon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567783,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,82567783)
	e1:SetCondition(c82567783.dwcon)
	e1:SetTarget(c82567783.dwtg)
	e1:SetOperation(c82567783.dwop)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c82567783.thcost)
	e3:SetTarget(c82567783.thtg)
	e3:SetOperation(c82567783.thop)
	c:RegisterEffect(e3)
	--fusion
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567783,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82567783+EFFECT_COUNT_CODE_DUEL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c82567783.fscon)
	e4:SetCost(c82567783.fscost)
	e4:SetTarget(c82567783.fstg)
	e4:SetOperation(c82567783.fsop)
	c:RegisterEffect(e4)
end
function c82567783.dwfilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567783.dwfilter2(c)
	return not c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567783.dwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567783.dwfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		  and not Duel.IsExistingMatchingCard(c82567783.dwfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567783.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c82567783.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c82567783.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567783.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
	end
function c82567783.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567783.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82567783.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567783.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82567783.fsfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c82567783.fscon(e,tp,eg,ep,ev,re,r,rp,chk,mg)
	return Duel.IsExistingMatchingCard(c82567783.ftgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c82567783.fscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ns=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567783.fsfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local fsm=Duel.SelectMatchingCard(tp,c82567783.fsfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if fsm:GetCount()>0 then
	Duel.Remove(ns,POS_FACEUP,REASON_EFFECT)
	Duel.Remove(fsm,POS_FACEUP,REASON_EFFECT)
end 
end
function c82567783.ftgfilter(c,e,tp,m,f,chkf,mg)
	return c:IsType(TYPE_FUSION) 
		  and c:IsSetCard(0xc825) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function c82567783.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567783.ftgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567783.fsop(e,tp,eg,ep,ev,re,r,rp,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567783.ftgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	  local  tc=g:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		 tc:CompleteProcedure()  
		Duel.ConfirmCards(1-tp,g)
	end
end
	
