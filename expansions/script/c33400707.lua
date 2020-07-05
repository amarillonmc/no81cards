--镜野七罪 布局的魔女
local m=33400707
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3342),2,true)
	 --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(cm.regtg)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.indcon)
	e1:SetOperation(cm.indop)
	c:RegisterEffect(e1)  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
 --
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x3342) and c:IsAbleToGrave()
end
function cm.setfilter(c)
	return c:IsSetCard(0x3342) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function cm.setfilter2(c)
	return c:IsSetCard(0x3342) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	or Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.chcon)
	e1:SetOperation(cm.chop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,m+2)==0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)) or (Duel.GetFlagEffect(tp,m+1)==0 and  
	 Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_DECK,0,1,nil))
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+1)>0 and Duel.GetFlagEffect(tp,m+2)>0  then return end
	local off=1
	local ops={}
	local opval={}
	if  Duel.GetFlagEffect(tp,m+1)==0 and  
	 Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_DECK,0,1,nil)  then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetFlagEffect(tp,m+2)==0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SSet(tp,tc)
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,0) 
	elseif opval[op]==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,0) 
	end
end

function cm.matval(c)
	if c:GetCode()~=c:GetOriginalCode() then return 1 end
	return 0
end
function cm.valcheck(e,c)
	local val=c:GetMaterial():GetSum(cm.matval)
	e:GetLabelObject():SetLabel(val)
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
   return  e:GetLabel()>0
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetCode()~=bc:GetOriginalCode()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_GRAVE,0,1,nil)and  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SSet(tp,tc)
	end
end
function cm.setfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSetCard(0x3342)
end

function cm.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	 local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	 Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=g:SelectSubGroup(tp,cm.check,false,1,2,tp)
	Duel.ChangePosition(g1,POS_FACEDOWN)
local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)
	 Duel.ShuffleSetCard(sg)
end
function cm.check(g,tp)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(Card.IsControler,1,nil,tp) then res=res+0x1 end
	if g:IsExists(Card.IsControler,1,nil,1-tp) then res=res+0x2 end  
	return res~=0x1 and res~=0x2 
end




