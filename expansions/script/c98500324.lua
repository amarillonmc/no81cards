--真祖之奥西里斯
function c98500324.initial_effect(c)
	aux.AddCodeList(c,10000020)
	aux.EnableChangeCode(c,10000020,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c98500324.selfspcon)
	e0:SetTarget(c98500324.selfsptg)
	e0:SetOperation(c98500324.selfspop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500324,4))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98500324.rmcon)
	e1:SetCountLimit(1,98500523)
	e1:SetTarget(c98500324.sttg)
	e1:SetOperation(c98500324.stop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500324,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500324)
	e2:SetCost(c98500324.thcost)
	e2:SetTarget(c98500324.thtg)
	e2:SetOperation(c98500324.thop)
	c:RegisterEffect(e2)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c98500324.adval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--disable spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e7:SetDescription(aux.Stringid(98500324,2))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_SPSUMMON)
	e7:SetCountLimit(1,98520305)
	e7:SetCondition(c98500324.condition)
	e7:SetTarget(c98500324.target)
	e7:SetOperation(c98500324.operation)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e8)
	local e10=e7:Clone()
	e10:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e10)
	--to grave
   local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(c98500324.regop)
	c:RegisterEffect(e9)
	--tohand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98500324,3))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetCountLimit(1)
	e11:SetCondition(c98500324.thscon)
	e11:SetTarget(c98500324.thstg)
	e11:SetOperation(c98500324.thsop)
	c:RegisterEffect(e11)
	Duel.AddCustomActivityCounter(98500324,ACTIVITY_SPSUMMON,c98500324.counterfilter)
end
function c98500324.counterfilter(c)
	return  c:IsRace(RACE_DIVINE)
end
function c98500324.selfspfilter(c,tp)
	return c:IsCode(10000020) and Duel.GetMZoneCount(tp,c)>0 and c:GetFlagEffect(7373632)>0
end
function c98500324.selfspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c98500324.selfspfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c98500324.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c98500324.selfspfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c98500324.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_SPSUMMON)
end
function c98500324.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98500324,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98500324.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98500324.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DIVINE)
end
function c98500324.filter(c)
	return (aux.IsCodeListed(c,10000020) or c:IsCode(10000040,42469671,59094601,74875003,10000020)) and c:IsAbleToHand()
end
function c98500324.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500324.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98500324.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsDiscardable() then
		if Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c98500324.filter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c98500324.cfilter(c,tp,g)
	return c:IsCode(10000020) and c:IsControler(tp) and c:GetOriginalLevel()==10 and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAbleToDeck() and (not g or g:IsContains(c))
end
function c98500324.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
function c98500324.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c98500324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c98500324.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c98500324.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local fg=eg:Filter(aux.NecroValleyFilter(c98500324.spfilter),nil,e,tp)
		local num=fg:GetCount()
		local dis=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)
		local zon=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if num>0 and zon>0 and dis>0 and Duel.SelectYesNo(tp,aux.Stringid(98500324,2)) then
			Duel.BreakEffect()
			local num=math.min(num,dis,zon)
			local ct=Duel.DiscardHand(tp,aux.TRUE,1,num,REASON_EFFECT+REASON_DISCARD)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=fg:Select(tp,ct,ct,nil)
			local tc=sg:GetFirst()
			while tc do
				Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
				tc:CompleteProcedure()
				tc=sg:GetNext()
			end
		end
	end
end
function c98500324.stfil(c) 
	return ((c:GetType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)) and (aux.IsCodeListed(c,10000020) or c:IsCode(10000040,42469671,59094601,74875003,10000020)) and c:IsSSetable() 
end 
function c98500324.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500324.stfil,tp,LOCATION_DECK,0,1,nil) end 
end 
function c98500324.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98500324.stfil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(98501324,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end 
function c98500324.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98501324)==0
end
function c98500324.thscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and not Duel.IsPlayerAffectedByEffect(tp,98500300) and c:GetFlagEffect(98500324)>0
end
function c98500324.thstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98500324.thsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c98500324.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98500324,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end