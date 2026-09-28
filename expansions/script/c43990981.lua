--百灵之验
function c43990981.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990981,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c43990981.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetDescription(aux.Stringid(43990981,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990981)
	e1:SetTarget(c43990981.target)
	e1:SetOperation(c43990981.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(43990981,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,43990981-1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43990981.drtg)
	e2:SetOperation(c43990981.drop)
	c:RegisterEffect(e2)
end
function c43990981.hcfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsFaceup()
end
function c43990981.cfilter(c)
	return c:IsCode(43990987) and c:IsFaceup()
end
function c43990981.handcon(e)
	return not Duel.IsExistingMatchingCard(c43990981.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c43990981.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c43990981.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rac=0
		local crac=1
		while bit.band(RACE_ALL,crac)~=0 do
			if Duel.IsPlayerCanSpecialSummonMonster(tp,43990981,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,crac,ATTRIBUTE_WIND) then rac=rac+crac end
			crac=crac*2
		end
		e:SetLabel(rac)
		return e:IsCostChecked() and rac~=0 and Duel.GetMZoneCount(tp)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local crac=Duel.AnnounceRace(tp,1,e:GetLabel())
	e:SetLabel(crac)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990981.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rac=e:GetLabel()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,43990981,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,rac,ATTRIBUTE_WIND) or not c:IsRelateToChain() then return end
	c:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_WIND,rac)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c43990981.tgfilter(c)
	return aux.IsCodeListed(c,43990987) and c:IsFaceupEx() and c:IsAbleToGrave()
end
function c43990981.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c43990981.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c43990981.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c43990981.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
