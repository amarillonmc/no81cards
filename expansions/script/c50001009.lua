--星空闪耀 无名使者
function c50001009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,50001009+EFFECT_COUNT_CODE_OATH)   
	e1:SetTarget(c50001009.actg) 
	e1:SetOperation(c50001009.acop) 
	c:RegisterEffect(e1)  
end
c50001009.SetCard_WK_StarS=true   
function c50001009.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsSetCard(0x99a) end,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsSetCard(0x99a) end,tp,LOCATION_MZONE,0,1,1,nil)  
end 
function c50001009.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then   
		--pos 
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(50001009,1))
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_QUICK_O) 
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)   
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)  
		e1:SetCost(c50001009.drcost) 
		e1:SetTarget(c50001009.drtg)
		e1:SetOperation(c50001009.drop)
		tc:RegisterEffect(e1) 
	end 
end 
function c50001009.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c50001009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c50001009.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end








