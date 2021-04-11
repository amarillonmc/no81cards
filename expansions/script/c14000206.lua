--噬界兽LV11-星噬形态
local m=14000206
local cm=_G["c"..m]
cm.named_with_Worlde=1
function cm.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.mtcon)
	e2:SetOperation(cm.mtop)
	c:RegisterEffect(e2)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.lvup={14000205}
cm.lvdn={14000200,14000201,14000202,14000203,14000204,14000205}
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(14000205) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),14000205,0,0,0)
		end
	end
end
function cm.splimit(e,se,sp,st)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,14000205)>0
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_WORLDEATER=0x24
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if ct>=79 then
		Duel.Win(tp,WIN_REASON_WORLDEATER)
	end
end