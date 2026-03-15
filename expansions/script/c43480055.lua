--被遗忘的研究 收容失效
function c43480055.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,43480055)   
	e1:SetTarget(c43480055.psptg)
	e1:SetOperation(c43480055.pspop)
	c:RegisterEffect(e1)
	--Special Summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,43480056) 
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c43480055.sptg)
	e2:SetOperation(c43480055.spop) 
	c:RegisterEffect(e2)
end
function c43480055.pspfil(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsDestructable(e))
end 

function c43480055.thfilter(c)
	return c:IsSetCard(0x3f13)
		and c:IsAbleToHand()
end

function c43480055.psptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c43480055.pspfil(chkc,e,tp) end 
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		or Duel.IsExistingMatchingCard(c43480055.thfilter,tp,LOCATION_DECK,0,1,nil)) 
		and Duel.IsExistingTarget(c43480055.pspfil,tp,LOCATION_PZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c43480055.pspfil,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c43480055.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end

	local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)

	local b2 = tc:IsDestructable(e)
		and Duel.IsExistingMatchingCard(c43480055.thfilter,tp,LOCATION_DECK,0,1,nil)

	if not (b1 or b2) then return end

	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43480055,2)}, -- 特召
		{b2,aux.Stringid(43480055,3)}  -- 破坏 + 检索
	)

	-- ● 特殊召唤
	if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)

	-- ● 破坏 → 检索
	elseif op==2 then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c43480055.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end  

function c43480055.spfilter(c,e,tp)
	return c:IsCode(4348030) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c43480055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c43480055.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c43480055.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43480055.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end




