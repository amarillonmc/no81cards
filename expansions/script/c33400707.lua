--镜野七罪 布局的魔女
local m=33400707
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter1,2,true)
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
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.excon)
	e1:SetTarget(cm.target2)
	e1:SetOperation(cm.activate2)
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
end
function cm.matfilter1(c)
	return  c:IsSetCard(0x3342) or c:GetCode()~=c:GetOriginalCode()
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
	e:SetLabel(val)
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
   return  e:GetLabel()>0
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ss=e:GetLabel()+e:GetHandler():GetFlagEffect(33400707)	
	c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
	if ss>1 then 
	for i=2,ss do 
	 c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,0,0,0)
	end
	end
end

function cm.excon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetFlagEffect(33400707)>0
end
function cm.cfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3342)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(cm.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,cm.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsFaceup() and tc:IsRelateToEffect(e)  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(lc:GetCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		if lc:IsRelateToEffect(e) and lc:IsControler(tp) then
			Duel.SendtoHand(lc,nil,REASON_EFFECT)
		end
	end
end

function cm.setfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_MONSTER) and c:IsCanTurnSet())
	and (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
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




