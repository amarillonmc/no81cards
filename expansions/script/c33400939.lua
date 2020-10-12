--D.A.L 诱宵美九
local m=33400939
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableReviveLimit()
   aux.AddFusionProcFunFunRep(c,cm.matfilter1,cm.ffilter,4,4,true)
  --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
   --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.hspcon)
	e1:SetOperation(cm.hspop)
	c:RegisterEffect(e1)
  --cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3)
 --atk
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.mvtg)
	e4:SetOperation(cm.mvop)
	c:RegisterEffect(e4)
  --check 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(2)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.cktg)  
	e5:SetOperation(cm.ckop)
	c:RegisterEffect(e5)
 --Equip Okatana
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetOperation(cm.Eqop1)
	c:RegisterEffect(e8)
end
function cm.matfilter1(c)
	return  c:IsSetCard(0xc341) 
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xc341) and not c:IsLevel(4)  and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end

function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function cm.cfilter1(c)
	return  c:IsSetCard(0x5340) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.cfilter2(c)
	return c:IsAbleToDeck() and   c:IsSetCard(0xc341) and c:IsLevel(4) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.cfilter3(c)
	return  c:IsAbleToDeck() and   c:IsSetCard(0xc341) and (not c:IsLevel(4)) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.hspcon(e,c)
	if c==nil then return true end
   local g1=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
   local g2=Duel.GetMatchingGroup(cm.cfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g1:GetCount()>3 and  Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and g2:GetClassCount(Card.GetCode)>=4
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(cm.cfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local sg
	if g2:GetCount()>=3 then
		 sg=g2:SelectSubGroup(tp,aux.dncheck,false,4,4)   
	end
	g1:Merge(sg)
	c:SetMaterial(g1)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
end

function cm.target(e,c)
	return c:IsSetCard(0x5340,0xc341) and c:IsFaceup()
end

function cm.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_HAND) 
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  not c:IsStatus(STATUS_BATTLE_DESTROYED) end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000*eg:GetCount())
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end   
end

function cm.cnfilter(c)
	return c:IsSetCard(0x5340) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cnfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end
function cm.thfilter(c)
	return c:IsSetCard(0xc341,0x5340)  and c:IsAbleToHand() 
end
function cm.cktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.spfilter1(c,e,tp)
	return  c:IsSetCard(0x341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ckop(e,tp,eg,ep,ev,re,r,rp)
  if   Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,nil) then 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	  Duel.SendtoHand(g1,nil,REASON_EFFECT)
  end 
   if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
   end
end

function cm.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		cm.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400940)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(cm.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(cm.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			 --inm
			local e3=Effect.CreateEffect(ec)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCountLimit(1)
			e3:SetOperation(cm.op3)
			token:RegisterEffect(e3)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function cm.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end

function cm.op3(e,tp,eg,ep,ev,re,r,rp)   
if not e:GetHandler():IsRelateToEffect(e) then return end
			local e3_1=Effect.CreateEffect(e:GetHandler())
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3_1:SetRange(LOCATION_SZONE)
			e3_1:SetCode(EFFECT_IMMUNE_EFFECT)
			e3_1:SetValue(cm.efilter3_1)
			e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+Duel.GetCurrentPhase())
			e:GetHandler():RegisterEffect(e3_1,true)
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
			end
	end
end
function cm.efilter3_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end