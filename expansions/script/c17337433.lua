--不存在的现在
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(17337400))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,c:GetControler())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)
	if #g==0 then return end

	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(s.spfilter,nil,e,tp)
		if #og<=0 then return end

		Duel.AdjustAll()

		local spg=Group.CreateGroup()
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		
		if ft1<=0 and ft2<=0 then return end

		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 and ft2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg=og:Select(tp,1,1,nil)
			else
				local p
				if ft1>0 and ft2<=0 then
					p=tp
				end
				if ft1<=0 and ft2>0 then
					p=1-tp
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg=og:FilterSelect(tp,Card.IsControler,1,1,nil,p)
			end
		else
			local p=tp
			for i=1,2 do
				local sg=og:Filter(Card.IsControler,nil,p)
				local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
				local max_sg=#sg
				if ft<max_sg then max_sg=ft end
				
				if max_sg>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
					local select_sg=sg:Select(p,max_sg,max_sg,nil)
					if #select_sg>0 then
						spg:Merge(select_sg)
					end
				end
				p=1-tp
			end
		end

		if #spg>0 then
			Duel.BreakEffect()
			local tc=spg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
				tc=spg:GetNext()
			end
			Duel.SpecialSummonComplete()
			local cg=spg:Filter(Card.IsFacedown,nil)
			if #cg>0 then
				Duel.ConfirmCards(1-tp,cg)
			end
		end
	end
end