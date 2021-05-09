--蚀异梦境-梦医院
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400041.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self to deck & field activation
	yume.AddYumeFieldGlobal(c,71400041,2)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_SSET+TIMING_BATTLE_START+TIMING_MAIN_END)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c71400041.tg1)
	e1:SetDescription(aux.Stringid(71400041,0))
	e1:SetCost(c71400041.cost1)
	e1:SetCondition(c71400041.con1)
	e1:SetOperation(c71400041.op1)
	c:RegisterEffect(e1)
end
function c71400041.con1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c71400041.filter1c(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsLinkState() and c:IsAbleToRemoveAsCost()
end
function c71400041.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400041.filter1c,tp,LOCATION_MZONE,0,1,nil) and Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c71400041.filter1c,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetDescription(aux.Stringid(71400041,1))
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c71400041.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c71400041.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c71400041.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c71400041.filter1(c,cid)
	return c:IsAbleToGrave() and c:IsCode(cid)
end
function c71400041.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if tc:IsLocation(LOCATION_GRAVE) then
			local p=tc:GetControler()
			local g=Duel.GetMatchingGroup(c71400041.filter1,p,LOCATION_DECK+LOCATION_HAND,0,nil,tc:GetCode())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
				g=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			end
			g:AddCard(tc)
			local lc=g:GetFirst()
			while lc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(c71400041.aclimit)
				e1:SetLabel(lc:GetCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,p)
				lc=g:GetNext()
			end
		end
	end
end
function c71400041.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end