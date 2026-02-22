--幽冥锻造师法科罗
local s,id=GetID()
function s.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.exctg)
	e2:SetOperation(s.excop)
	c:RegisterEffect(e2)
end
function s.spcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.exctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function s.thfilter(c)
	if not ((c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsType(TYPE_EQUIP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function s.excop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	local sp=false
	local ct=5
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:IsExists(Card.IsSetCard,3,nil,0xd70) then sp=true end
	if g:IsExists(s.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:FilterSelect(tp,s.thfilter,1,1,nil):GetFirst()
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
			ct=ct-1
		else
			Duel.DisableShuffleCheck()
			Duel.SSet(tp,tc)
			ct=ct-1
		end
	end
	local c=e:GetHandler()
	if sp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsLocation(LOCATION_GRAVE) or aux.NecroValleyFilter()(c)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SortDecktop(tp,tp,ct)
end