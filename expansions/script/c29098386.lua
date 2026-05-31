--方舟骑士团-歌蕾蒂娅
function c29098386.initial_effect(c)
	--SpecialSummon/To deck or hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29098386,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,29098386)
	e3:SetCondition(c29098386.spcon)
	e3:SetTarget(c29098386.sptg)
	e3:SetOperation(c29098386.spop)
	c:RegisterEffect(e3)
	--Control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29098387,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29098387)
	e1:SetCondition(c29098386.concon)
	e1:SetTarget(c29098386.contg)
	e1:SetOperation(c29098386.conop)
	c:RegisterEffect(e1)
end
--SpecialSummon/To deck or hand
function c29098386.vfilter(c,tp)
	return (c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)) or (c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsControler(1-tp))
end
function c29098386.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29098386.vfilter,1,nil,tp)
end
function c29098386.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsAbleToDeck() or c:IsAbleToHand())
end
function c29098386.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29098386.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and g:GetCount()>0) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29098386.spop(e,tp,eg,ep,ev,re,r,rp,op)
	local c=e:GetHandler()
	if op==nil then
		local g=Duel.GetMatchingGroup(c29098386.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		local chk=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local chk2=g:GetCount()>0
		local chk3=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:GetCount()>0
		op=aux.SelectFromOptions(tp,
			{chk,aux.Stringid(29098386,5)},
			{chk2,aux.Stringid(29098386,6)},
			{chk3,aux.Stringid(29098386,7)})
	end
	if op&1>0 then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		if op==3 then Duel.BreakEffect() end
	end
	if op&2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g1=Duel.GetMatchingGroup(c29098386.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if g1:GetCount()>0 then
			local dg=g1:Select(tp,1,1,nil)
			if dg:GetFirst():IsAbleToHand() and (not dg:GetFirst():IsAbleToDeck() or Duel.SelectOption(tp,aux.Stringid(29098386,3),aux.Stringid(29098386,4))==0) then
				Duel.SendtoHand(dg,nil,REASON_EFFECT)
			elseif dg:GetFirst():IsAbleToDeck() then   
				Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
--Control
function c29098386.concon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c29098386.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c29098386.conop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp)
	end
end


















