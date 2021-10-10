--阿米娅·瑟谣浮收藏-Neo Soul
function c79029433.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79029433.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_MZONE+LOCATION_REMOVED,0,aux.tdcfop(c)):SetValue(1) 
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c79029433.cptg)
	e1:SetOperation(c79029433.cpop)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029359)
	c:RegisterEffect(e2)	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029433,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,79029433)
	e3:SetCost(c79029433.nscost)
	e3:SetTarget(c79029433.nstg)
	e3:SetOperation(c79029433.nsop)
	c:RegisterEffect(e3)
		if not c79029433.global_check then
		c79029433.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c79029433.checkop)
		Duel.RegisterEffect(ge1,0)
end 
end
function c79029433.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(79029433,RESET_PHASE+PHASE_END,0,1)
end
function c79029433.ffilter(c,fc,sub,mg,sg)
	return (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and (not sg or sg:IsExists(Card.IsCode,1,nil,79029359)) and c:IsType(TYPE_MONSTER)
end
function c79029433.cpfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900)
end
function c79029433.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) or e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)) and e:GetHandler():GetMaterial():IsExists(c79029433.cpfil,1,nil) end
end
function c79029433.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial():Filter(Card.IsType,nil,TYPE_MONSTER)
	local tc=mg:FilterSelect(tp,c79029433.cpfil,1,1,nil):GetFirst()
	local code=tc:GetCode()
	if code==79029025 or code==79029215 then 
	Debug.Message("赤霄的影子萦绕着我的剑。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029433,3))
	else
	Debug.Message("行动开始。我们走！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029433,2))
	end
	Duel.MajesticCopy(c,tc)
	e:GetHandler():SetHint(CHINT_CARD,code)
end
function c79029433.nsfil(c)
	return c:GetFlagEffect(79029433)~=0 
end
function c79029433.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local x=Duel.GetMatchingGroup(c79029433.nsfil,tp,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,nil):GetCount()
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/1000)
	local l=1
	while l<=f and l<=x do
		t[l]=l*1000
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029433,1))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce/1000)
end
function c79029433.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c79029433.nsfil,tp,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,nil)
	if chk==0 then return g:GetCount()>0 end
end
function c79029433.xxfil(c,code)
	return c:IsOriginalCodeRule(code)
end
function c79029433.nsop(e,tp,eg,ep,ev,re,r,rp,chk)
	Debug.Message("“我该用什么回应你的不义？”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029433,4))
	local c=e:GetHandler()
	local op=e:GetLabel()
	local g=Duel.GetMatchingGroup(c79029433.nsfil,tp,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,nil):Select(tp,op,op,nil)
	local tc=g:GetFirst()
	while tc do 
	local sg=Duel.GetMatchingGroup(c79029433.xxfil,tp,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_OVERLAY,nil,tc:GetOriginalCodeRule())
	local xc=sg:GetFirst()
	while xc do
	if xc:GetOriginalCodeRule()==79029433 then
	Debug.Message("......发生什么了？不应该是这样......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029433,5))
	end
	xc:ReplaceEffect(23995346,0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabelObject(xc)
	e1:SetLabel(xc:GetOriginalCodeRule())
	e1:SetCondition(c79029433.rtcon)
	e1:SetOperation(c79029433.rtop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	xc=sg:GetNext() 
	end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c79029433.discon)
		e2:SetOperation(c79029433.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	tc=g:GetNext()
	end  
end
function c79029433.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c79029433.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,09029433)==0 then
	Duel.Hint(HINT_CARD,0,79029433)
	Debug.Message("你的想法，你的法术，我都能切开。")
	end
	Duel.RegisterFlagEffect(tp,09029433,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029433,6))
	Duel.ChangeChainOperation(ev,c79029433.repop)
end
function c79029433.repop(e,tp,eg,ep,ev,re,r,rp)
end
function c79029433.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp 
end
function c79029433.rtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,79029433)==0 then
	Debug.Message("咻，应该可以小小休息一下了吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029433,7))
	end
	Duel.RegisterFlagEffect(tp,79029433,RESET_PHASE+PHASE_END,0,1)
	local tc=e:GetLabelObject()
	tc:ReplaceEffect(e:GetLabel(),0)
	e:Reset()
end


