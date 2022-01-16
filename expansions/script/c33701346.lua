--瞄准的女王 梓璃梦
function c33701346.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33701346.ffilter,2,true)  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetCondition(c33701346.rule)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701346,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33701346.tgcon)
	e2:SetTarget(c33701346.tgtg)
	e2:SetOperation(c33701346.tgop)
	c:RegisterEffect(e2)
	if not c33701346.global_check then
		c33701346.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c33701346.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33701346.rule(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,33701346)>0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c33701346.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetAttackTarget()==nil and Duel.GetFieldGroupCount(eg:GetFirst():GetControler(),0,LOCATION_MZONE)>0) then return nil end
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetControler(),33701346,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c33701346.ffilter(c,fc,sub,mg,sg)
	return c:IsAttackBelow(1000) and c:GetDefense()>c:GetAttack()
end
function c33701346.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c33701346.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1000,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
end
function c33701346.tgfilter(c,atk)
	return c:GetAttack()<atk and c:IsAbleToGrave() and c:IsFaceup()
end
function c33701346.tgop(e,tp,eg,ep,ev,re,r,rp)
	local a1=e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup()
	local a2=Duel.IsExistingMatchingCard(c33701346.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
	local op==2
	if a1 and a2 then
		op=Duel.SelectOption(tp,aux.Stringid(33701346,1),aux.Stringid(33701346,2))
	elseif a1 then
		op=Duel.SelectOption(tp,aux.Stringid(33701346,1))
	elseif a2 then
		op=Duel.SelectOption(tp,aux.Stringid(33701346,2))+1
	end
	if op==0  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,c33701346.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler():GetAttack())
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end