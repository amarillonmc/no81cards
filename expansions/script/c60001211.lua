--亚里沙的小本本
local m=60001211
local cm=_G["c"..m]
function cm.initial_effect(c)
	--查询玩家任务进度
	local e4=Effect.CreateEffect(c)--融合或使用财宝卡的次数
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA) 
	e4:SetOperation(cm.op1)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)--进化次数
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA) 
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
	--
	if not cm.global_check then
		cm.global_check=true
		--融合或使用财宝卡的次数
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end


--融合或使用财宝卡的次数:60001211
--进化次数:60001212





--查询玩家任务进度
function cm.op1(e,tp,eg,ep,ev,re,r,rp,nm)  --融合或使用财宝卡的次数
	Debug.Message(Duel.GetFlagEffect(tp,60001211))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,nm)  --进化次数
	Debug.Message(Duel.GetFlagEffect(tp,60001212))
end








--融合或使用财宝卡的次数
function cm.checkop1(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local w=te:GetHandler()
		if tgp==tp and w:IsSetCard(0x6a6) then
			return Duel.RegisterFlagEffect(tp,60001211,RESET_PHASE+PHASE_END,0,1000)
		end  
	end
end