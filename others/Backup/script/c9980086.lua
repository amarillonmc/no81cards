--风神录-光子鱼雷
function c9980086.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9980086.lcheck)
	c:EnableReviveLimit()
	--draw(spsummon)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980086,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9980086)
	e2:SetTarget(c9980086.target)
	e2:SetOperation(c9980086.operation)
	c:RegisterEffect(e2)
  --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980086.atkval)
	c:RegisterEffect(e1)
  --draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99800860)
	e2:SetCost(c9980086.drawcost)
	e2:SetTarget(c9980086.drawtg)
	e2:SetOperation(c9980086.drawop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980086.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980086.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980086,1))
end
function c9980086.hspfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) 
end
function c9980086.lcheck(g,lc)
	return g:IsExists(c9980086.hspfilter,1,nil)
end
function c9980086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980086.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and (tc:IsSetCard(0x3bc6) or tc:IsAttribute(ATTRIBUTE_WATER)) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9980086,1)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c9980086.atkfilter(c)
	return c:IsFaceup() 
end
function c9980086.atkval(e,c)
	local g=Duel.GetMatchingGroup(c9980086.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLevel)*200
end
function c9980086.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x3bc6) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x3bc6)
	Duel.Release(g,REASON_COST)
end
function c9980086.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980086.sfilter(c,e,tp)
	return c:IsSetCard(0x3bc6) and c:IsType(TYPE_MONSTER) and not c:IsCode(9980086)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c9980086.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-p,tc)
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x3bc6) then
			local sel=1
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9980086,0))
			if Duel.IsExistingMatchingCard(c9980086.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
				sel=Duel.SelectOption(tp,1213,1214)
			else
				sel=Duel.SelectOption(tp,1214)+1
			end
			if sel==0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sc=Duel.SelectMatchingCard(tp,c9980086.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
					and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				else
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				end
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
