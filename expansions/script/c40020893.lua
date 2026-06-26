--泰兹卡特尔之壳
local s,id=GetID()

s.named_with_ArmoredBeast=1

function s.ArmoredBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArmoredBeast
end

function s.initial_effect(c) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rittg)
	e1:SetOperation(s.ritop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.matfilter1(c)
	return c:GetLevel()>0 and c:IsReleasable()
end

function s.matfilter2(c)
	return c:GetLevel()>0 and s.ArmoredBeast(c) and c:IsAbleToRemove()
end

function s.get_mat_group(tp,exc_c)
	local mg=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,exc_c)
	local mg2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_DECK,0,exc_c)
	mg:Merge(mg2)
	return mg
end

function s.fselect(g,lv,tp)
	local sum=g:GetSum(Card.GetLevel)
	if sum<lv then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
	end
	return true
end

function s.fselect_exact(g,lv,tp)
	local sum=g:GetSum(Card.GetLevel)
	if sum<lv then return false end
	if sum-g:GetFirst():GetLevel()>=lv and #g>1 then
		for tc in aux.Next(g) do
			if sum-tc:GetLevel()>=lv then return false end
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
	end
	return true
end

function s.ritfilter(c,e,tp)
	if not (s.ArmoredBeast(c) and c:IsType(TYPE_RITUAL)) then return false end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local lv=c:GetLevel()
	local mg=s.get_mat_group(tp,c)
	return mg:CheckSubGroup(s.fselect,1,#mg,lv,tp)
end

function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		local mg=s.get_mat_group(tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,s.fselect_exact,false,1,#mg,lv,tp)
		if not mat or #mat==0 then return end
		tc:SetMaterial(mat)
		local mat_rel=mat:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
		local mat_rem=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		local ct_rel=0
		local ct_rem=0
		if #mat_rel>0 then
			ct_rel=Duel.Release(mat_rel,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if #mat_rem>0 then
			ct_rem=Duel.Remove(mat_rem,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if ct_rel+ct_rem>0 then
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
			end
		end
	end
end

function s.rmfilter(c)
	return s.ArmoredBeast(c) and not c:IsCode(id) and c:IsAbleToRemove()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		   and (c:IsAbleToHand() or c:IsAbleToDeck())
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsType(TYPE_RITUAL) end,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and (c:IsAbleToHand() or c:IsAbleToDeck()) then
			local op=0
			if c:IsAbleToHand() and c:IsAbleToDeck() then
				op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) 
			elseif c:IsAbleToHand() then
				op=0
			else
				op=1
			end
			local res=0
			if op==0 then
				res=Duel.SendtoHand(c,nil,REASON_EFFECT)
			else
				res=Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
			if res>0 then
				local has_ritual = Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsType(TYPE_RITUAL) end,tp,LOCATION_MZONE,0,1,nil)
				if has_ritual and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
					Duel.BreakEffect()
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end