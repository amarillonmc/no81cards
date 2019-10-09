--终焉邪魂 暗影魔女阿洛巴斯
function c30000001.initial_effect(c)
	 c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c30000001.spcon)
	e1:SetOperation(c30000001.spop)
	c:RegisterEffect(e1)
	--Set 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30000001,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,30000001)
	e2:SetCondition(c30000001.con1)
	e2:SetCost(c30000001.cost1)
	e2:SetTarget(c30000001.tg1)
	e2:SetOperation(c30000001.op1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30000001,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,30000002)
	e3:SetCondition(c30000001.con2)
	e3:SetCost(c30000001.cost2)
	e3:SetTarget(c30000001.tg2)
	e3:SetOperation(c30000001.op2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,30000003)
	e4:SetTarget(c30000001.tg3)
	e4:SetOperation(c30000001.op3)
	c:RegisterEffect(e4)
end
function c30000001.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c30000001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,2,nil) or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 end
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and (Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)<2 or Duel.SelectYesNo(tp,aux.Stringid(30000001,1))) then
		local g1=Group.CreateGroup()
	else
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c30000001.tg1fil(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsSSetable()
end
function c30000001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=re:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c30000001.tg1fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,code) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c30000001.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local code=re:GetHandler():GetCode()
	local g=Duel.SelectMatchingCard(tp,c30000001.tg1fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,code)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end


function c30000001.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c30000001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return rg:IsExists(c30000001.spcfil,1,nil,tp) end
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,3,3,nil)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c30000001.spcfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,g1)
		g1:Merge(g2)
		sg:Merge(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c30000001.tg2fil(c,e,tp)
	return c:IsSetCard(0x920) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c30000001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ba=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	local m=0
	if ba then m=1 end
	e:SetLabel(m)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000001.tg2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c30000001.op2fil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c30000001.op2(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if m==1 and Duel.IsExistingMatchingCard(c30000001.op2fil,tp,LOCATION_HAND+LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(30000001,3)) then
		local g=Duel.SelectMatchingCard(tp,c30000001.op2fil,tp,LOCATION_HAND+LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		local g2=Duel.SelectMatchingCard(tp,c30000001.tg2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c30000001.tg3fil(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c30000001.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ba=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	if chk==0 then return Duel.IsExistingMatchingCard(c30000001.tg3fil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and (Duel.IsPlayerCanDraw(tp) or not ba) end
	local m=0
	if ba then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		m=1
	else
		e:SetCategory(CATEGORY_TOHAND)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
	e:SetLabel(m)
end
function c30000001.op3(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c30000001.tg3fil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local code=tc:GetCode()
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c30000001.aclimit)
			e1:SetLabel(code)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			if m==1 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function c30000001.aclimit(e,re,tp)
	 return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())  
end



function c30000001.spcfil(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemoveAsCost()
end
function c30000001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local count=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_GRAVE,0,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	return count==0 and rg:GetCount()>2 and rg:IsExists(c30000001.spcfil,1,nil,tp)
end
function c30000001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,3,c)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c30000001.spcfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
		g1:AddCard(c)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,g1)
		g1:RemoveCard(c)
		g1:Merge(g2)
		sg:Merge(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end