--龙门·行动-飒爽下班
function c79029317.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79029317.reccost)
	e1:SetTarget(c79029317.rectg)
	e1:SetOperation(c79029317.recop)
	c:RegisterEffect(e1)   
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029317)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c79029317.xgop)
	c:RegisterEffect(e2)
end
function c79029317.xfil(c)
	return c:IsSetCard(0x1905) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c79029317.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029317.xfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c79029317.xfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabel(tc:GetBaseAttack())
end
function c79029317.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c79029317.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,1,REASON_EFFECT)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c79029317.xgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c79029317.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029317.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsSetCard(0x1905) then
	Duel.Hint(HINT_CARD,0,79029317)
	Duel.SetChainLimit(c79029317.chainlm)
	end
end
function c79029317.chainlm(e,rp,tp)
	return tp==rp
end












