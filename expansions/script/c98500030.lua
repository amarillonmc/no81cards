--混沌幻魔 拉比艾尔
local m=98500030
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,69890967,cm.ffilter,1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--code
	aux.EnableChangeCode(c,69890967,LOCATION_MZONE+LOCATION_GRAVE)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69890967,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	local e1_1=e1:Clone()
	e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1_1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)  -- 自身在怪兽区域才生效
	e2:SetTargetRange(LOCATION_ONFIELD,0)  -- 己方全场区域
	e2:SetTarget(aux.TargetBoolFunction(Card.IsControler,0))
	e2:SetValue(c98500030.tgval)  -- 防止被对方陷阱取对象
	c:RegisterEffect(e2)
	--disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCondition(cm.condition2)
	e3:SetCost(cm.cost2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end
function c98500030.tgval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-e:GetHandlerPlayer()
end
function cm.ffilter(c,fc,sub,mg,sg)
	return  c:IsLevel(10)
end
function cm.lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(10)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)<Duel.GetMatchingGroupCount(cm.lvcheck,tp,LOCATION_MZONE,0,nil) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,69890968,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetFlagEffect(tp,m)<Duel.GetMatchingGroupCount(cm.lvcheck,tp,LOCATION_MZONE,0,nil) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,69890968,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,69890968)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function cm.etarget(e,c)
	return true
end
function cm.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(10)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_MONSTER) and Duel.GetFlagEffect(tp,111111113)<Duel.GetMatchingGroupCount(cm.lvcheck,tp,LOCATION_MZONE,0,nil) end
	Duel.RegisterFlagEffect(tp,111111113,RESET_PHASE+PHASE_END,0,1)
	local sg=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	Duel.Release(sg,REASON_COST)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end