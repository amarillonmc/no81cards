--延时融合
function c10173056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(10173056,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10173056.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173056,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10173056.thcon)
	e2:SetTarget(c10173056.thtg)
	e2:SetOperation(c10173056.thop)
	c:RegisterEffect(e2)
	if not c10173056.global_check then
		c10173056.global_check=true
		c10173056[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c10173056.clear)
		Duel.RegisterEffect(ge1,0)
		c10173056.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c10173056.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c10173056.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10173056)>0
end
function c10173056.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10173056.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c10173056.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousPosition(POS_FACEUP) and tc:IsType(TYPE_FUSION) then
		   Duel.RegisterFlagEffect(tc:GetPreviousControler(),10173056,RESET_PHASE+PHASE_END,0,1)
		end
	tc=eg:GetNext()
	end
end
function c10173056.clear(e,tp,eg,ep,ev,re,r,rp)
	c10173056[0]=0
end
function c10173056.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFusionSummonableCard,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		  if tc:GetFlagEffect(10173056)==0 then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_FIELD)
			 e1:SetDescription(aux.Stringid(10173056,0))
			 e1:SetCode(EFFECT_SPSUMMON_PROC)
			 e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			 e1:SetRange(LOCATION_EXTRA)
			 e1:SetValue(SUMMON_TYPE_FUSION)
			 e1:SetReset(RESET_PHASE+PHASE_END)
			 e1:SetCondition(c10173056.spcon)
			 e1:SetOperation(c10173056.spop)
			 tc:RegisterEffect(e1)
			 tc:RegisterFlagEffect(10173056,RESET_PHASE+PHASE_END,0,0)
		   end
	tc=g:GetNext()
	end 
	c10173056[0]=c10173056[0]+1
end
function c10173056.filter1(c,fc)
	return c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and c:IsType(TYPE_MONSTER)
end
function c10173056.spcon(e,c)
	if c10173056[0]==0 then return false end
	if c==nil then return true end
	local tp=c:GetControler()
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c10173056.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	return c:CheckFusionMaterial(mg,nil,chkf)
end
function c10173056.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c10173056.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	local mat=Duel.SelectFusionMaterial(tp,c,mg,nil,chkf)
	c:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_FUSION+REASON_COST+REASON_MATERIAL)
	c10173056[0]=c10173056[0]-1
end