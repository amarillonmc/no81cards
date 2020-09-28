--镜野七罪 布局的魔女
local m=33400707
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3342),2,true)
	 --search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(cm.chcon)
	e5:SetTarget(cm.regtg)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
 --indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(cm.indcon)
	e6:SetOperation(cm.indop)
	c:RegisterEffect(e6)  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--ex
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.excon)
	e1:SetTarget(cm.target2)
	e1:SetOperation(cm.activate2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e1)
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
  --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
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

function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,m+2)==0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)) or (Duel.GetFlagEffect(tp,m+1)==0 and  
	 Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_DECK,0,1,nil))
end
function cm.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	or Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
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
	 c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
end

function cm.excon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetFlagEffect(33400707)>0
end
function cm.filter2(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() 
end
function cm.filter4(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()  and c:IsRelateToEffect(e) 
end
function cm.setfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSetCard(0x3342)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=eg:Filter(cm.filter2,nil)
	if chk==0 then return sg:GetCount()>0   end
	Duel.SetTargetCard(eg)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=eg:Filter(cm.filter4,nil,e)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(m)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0) 
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,5))   
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e6)
			tc=tg:GetNext()
		end
	end
	 if Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_GRAVE,0,1,nil)and  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SSet(tp,tc)
	end
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




