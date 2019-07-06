--动物朋友 美洲豹
function c33700078.initial_effect(c)
	c33700078[c]={}
	local effect_list=c33700078[c]
	   --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700078.cost)
	e1:SetTarget(c33700078.target)
	e1:SetOperation(c33700078.operation)
	c:RegisterEffect(e1)
  --deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700078,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33700078)
	e2:SetLabel(5)
	effect_list[5]=e2
	e2:SetCondition(c33700078.effcon)
	e2:SetTarget(c33700078.tg)
	e2:SetOperation(c33700078.op)
	c:RegisterEffect(e2)
 --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700078,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33700080)
	e3:SetLabel(12)
	effect_list[12]=e3
	e3:SetCondition(c33700078.effcon)
	e3:SetTarget(c33700078.sptg)
	e3:SetOperation(c33700078.spop)
	c:RegisterEffect(e3)
  --sp2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,33700081) 
	e4:SetLabel(21)
	effect_list[21]=e4
	e4:SetCondition(c33700078.effcon2)
	e4:SetTarget(c33700078.sptg2)
	e4:SetOperation(c33700078.spop2)
	c:RegisterEffect(e4)
end
function c33700078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700078.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700078)
end
function c33700078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700078.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700078.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700078.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33700078.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700078.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700078.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700078.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700078.effcon(e)
	local g=Duel.GetMatchingGroup(c33700078.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090
end
function c33700078.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return  Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c33700078.tgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function c33700078.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		local sg=g:Filter(c33700078.tgfilter,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
		Duel.ShuffleDeck(p)
end
function c33700078.spfilter(c,e,tp)
	return c:IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700078.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700078.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33700078.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700078.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
	 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33700078.effcon2(e)
	local g=Duel.GetMatchingGroup(c33700078.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() 
end
function c33700078.filter(c,e,tp,id)
	return  not c:IsReason(REASON_RETURN) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x442)
end
function c33700078.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return  Duel.GetMZoneCount(tp)>0 and
	 Duel.IsExistingMatchingCard(c33700078.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount())
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c33700078.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	local tg=Duel.GetMatchingGroup(c33700078.filter,tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
