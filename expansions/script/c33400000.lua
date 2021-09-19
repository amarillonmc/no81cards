--星眼
XY=XY or {}
XY.loaded_metatable_list={}
------
function XY.REZS(c)
if c:IsSetCard(0x5349) and not (c:GetCode()==33403501) then 
		--set
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ge2:SetCode(EVENT_PHASE+PHASE_END)
	ge2:SetRange(LOCATION_GRAVE)
	ge2:SetCondition(XY.recon)
	ge2:SetCost(XY.recost)
	ge2:SetTarget(XY.resettg)
	ge2:SetOperation(XY.resetop)
	c:RegisterEffect(ge2)
else 
 --draw
	local ge3=Effect.CreateEffect(c)
	ge3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ge3:SetRange(LOCATION_GRAVE)
	ge3:SetCode(EVENT_PHASE+PHASE_END)
	ge3:SetCondition(XY.recon)
	ge3:SetCost(XY.recost)
	ge3:SetTarget(XY.drtg)
	ge3:SetOperation(XY.drop)
	c:RegisterEffect(ge3)
end 
if c:IsSetCard(0x5349) and  c:IsType(TYPE_TRAP) then 
  --act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(XY.handcon)
	c:RegisterEffect(e3)
end
	if not XY.zs then
		XY.zs=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)   
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(XY.zsop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function XY.zsfilter1(c,rp)
	return   Duel.GetFlagEffect(rp,33443500)==0  
end
function XY.zsckfilter1(c,rp,re)
	return c:GetSummonPlayer()==rp and   not c:IsCode(33403500) and (re and not re:GetHandler():IsSetCard(0x5349))
end
function XY.zsop1(e,tp,eg,ep,ev,re,r,rp)
	if  eg:IsExists(XY.zsckfilter1,1,nil,rp,re)  then   
	Duel.RegisterFlagEffect(rp,33443500,RESET_PHASE+PHASE_END,0,1)
	end 
end

function XY.handcon(e)
	return Duel.IsExistingMatchingCard(XY.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
function XY.hdfilter(c)
	return c:IsFaceup() and   c:IsCode(33403500) 
end

function XY.recost(e,tp,eg,ep,ev,re,r,rp,chk)  
if chk==0 then return   aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)  end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(XY.REsplimit)
	Duel.RegisterEffect(e1,tp) 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function XY.REsplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349) and  not c:IsCode(33403500)
end

function XY.recon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,33413502)<Duel.GetTurnCount() and Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and Duel.GetFlagEffect(tp,33443500)==0   
end
function XY.REstfilter(c,m)
	return c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(m)
end
function XY.resettg(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(XY.REstfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413502,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
end
function XY.resetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,XY.REstfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

function XY.drfilter(c,e)
	return c:IsSetCard(0x5349) and c:IsAbleToDeck() 
end
function XY.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(XY.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)  and g:GetClassCount(Card.GetCode)>=5  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413502,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)
end
function XY.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(XY.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	if g:GetClassCount(Card.GetCode)>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
	end
end
------mayuri
function XY.mayuri(c)
local cd=c:GetCode()
	if not c:IsLevel(12) then
--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(XY.mayuribfcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e0:SetOperation(XY.mayuriregop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(XY.mayuriregcon)
	e1:SetOperation(XY.mayuriregop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(XY.mayuriregcon)
	e2:SetOperation(XY.mayuriregop2)
	c:RegisterEffect(e2)
	end
	if c:IsLevel(4) then 
	  --spsummon
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e5:SetCode(EVENT_SUMMON_SUCCESS)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetRange(LOCATION_HAND)
		e5:SetCountLimit(1,cd)
		e5:SetCondition(XY.mayurispcon)   
		e5:SetTarget(XY.mayurisptg)
		e5:SetOperation(XY.mayurispop)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e6)
	end
	if c:IsLevel(8) then 
	--sp
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,cd)
	e5:SetCondition(XY.mayurispcon2)
	e5:SetTarget(XY.mayurisptg2)
	e5:SetOperation(XY.mayurispop2)
	c:RegisterEffect(e5)
	end
end
--inside
function XY.mayuribfcon(e)
	return e:GetHandler():GetFlagEffect(e:GetHandler():GetCode())==0
end
function XY.mayuriregop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
end
function XY.mayuriregcon(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler()==e:GetHandler()
end
function XY.mayuriregop1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
end
function XY.mayuriregop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local fs=c:GetFlagEffect(c:GetCode())
	c:ResetFlagEffect(c:GetCode())
	for i=1,fs-1 do
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
	end
end
--sp
function XY.mayuricfilter(c,at)
	return c:IsFaceup() and( c:IsSetCard(0x6344) or c:GetAttribute()&at~=0)
end
function XY.mayurispcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(XY.mayuricfilter,1,nil,c:GetAttribute()) 
end
function XY.mayurisptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function XY.mayurispop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or   not c:IsRelateToEffect(e)  then return end
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
end
--leave sp
function XY.mayurispcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and  c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function XY.mayurispfilter2(c,e,tp,at)
	return  c:IsSetCard(0x341) and c:IsLevel(4) and c:IsAttribute(at) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function XY.mayurisptg2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(XY.mayurispfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function XY.mayurispop2(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,XY.mayurispfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetAttribute())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
------magane
function XY.magane(c)
local cd=c:GetCode()
if c:IsType(TYPE_QUICKPLAY) then 
   --activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(XY.maganehandcon)
	c:RegisterEffect(e0)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33403521,2))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL) 
	e2:SetCountLimit(1,cd+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(XY.maganechcon)
	e2:SetCost(XY.maganechcost)
	e2:SetTarget(XY.maganetg)
	e2:SetOperation(XY.maganechop)
	e2:SetLabel(cd)
	c:RegisterEffect(e2)
end
   
end
function XY.maganehdfilter(c)
	return c:IsFaceup() and c:IsCode(33403520)
end
function XY.maganehandcon(e)
	return Duel.IsExistingMatchingCard(XY.maganehdfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end

function XY.maganechcon(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp
end
function XY.maganecostfilter1(c)
	return  c:IsSetCard(0x6349) or c:IsCode(33403520) 
end
function XY.maganechcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(XY.maganecostfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,XY.maganecostfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	Duel.ConfirmCards(1-tp,tc)  
end
function XY.maganetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	if cd==33403521 then  
	   e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	elseif cd==33403522 then 
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	elseif cd==33403523 then 
	   e:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	 elseif cd==33403524 then 
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	 elseif cd==33403525 then 
		 e:SetCategory(CATEGORY_CONTROL+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	 elseif cd==33403526 then 
		 e:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	elseif cd==33403527 then 
		e:SetCategory(CATEGORY_TOHAND)
	elseif cd==33403528 then 
	  e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	 elseif cd==33403529 then 
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function XY.maganechop(e,tp,eg,ep,ev,re,r,rp)
	local cd=e:GetLabel()
	local ck=0
	if Duel.GetFlagEffect(tp,33433530)>0 or (Duel.GetFlagEffect(tp,33403530)>0 and Duel.GetFlagEffect(tp,33423530)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403530,2)))	then 
	ck=1
	Duel.RegisterFlagEffect(tp,33423530,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
	end
	local gg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.ConfirmCards(1-tp,gg)
	if cd==33403521 then  
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop1)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetCondition(XY.maganecon1)
			e1:SetOperation(XY.maganeop1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	elseif cd==33403522 then 
		if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop2)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop2)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	elseif cd==33403523 then 
		if Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,2,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and ((ck==1  and 
		Duel.SelectYesNo(tp,aux.Stringid(cd,3)))
		or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop3)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop3)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			 Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	 elseif cd==33403524 then 
		if  Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and ((ck==1  and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop4)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop4)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	 elseif cd==33403525 then 
		if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop5)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop5)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	 elseif cd==33403526 then 
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop6)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop6)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	elseif cd==33403527 then 
		if Duel.IsExistingMatchingCard(XY.maganeckfilter7,tp,LOCATION_GRAVE,0,1,nil) and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop7)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop7)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	elseif cd==33403528 then 
		if  ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop8)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop8)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	 elseif cd==33403529 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=4 and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop9)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop9)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	elseif cd==33403530 then 
		if Duel.IsExistingMatchingCard(XY.maganeckfilter10,tp,LOCATION_GRAVE,0,1,nil,tp) and ((ck==1 and Duel.SelectYesNo(tp,aux.Stringid(cd,3))) or  (ck==0 and Duel.SelectYesNo(1-tp,aux.Stringid(cd,3)))) then 
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)  
			Duel.ChangeChainOperation(ev,XY.maganetrickop10)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetOperation(XY.maganeop10)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,33403521,0,0,0)
		end
	end
end
function XY.maganethfilter1(c)
	return  c:IsSetCard(0x6349) and c:IsAbleToHand()
end
function XY.maganetrickop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,0,LOCATION_DECK+LOCATION_GRAVE,1,nil) and 
	Duel.SelectYesNo(1-tp,aux.Stringid(33403521,4)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(1-tp,XY.maganethfilter1,1-tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	end
 Duel.RegisterFlagEffect(tp,33413521,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganecon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,LOCATION_DECK,0,1,nil)
end
function XY.maganeop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,XY.maganethfilter1,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function XY.maganethfilter2(c)
	return  not c:IsCode(33403522) and c:IsAbleToHand()
end
function XY.maganetrickop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,nil,1-tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g1:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_RULE+REASON_EFFECT)~=0  then
		if Duel.SelectYesNo(tp,aux.Stringid(33403522,4)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,XY.maganethfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
			if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
			end
		end
		if Duel.SelectYesNo(1-tp,aux.Stringid(33403522,4)) then 
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(1-tp,XY.maganethfilter2,1-tp,LOCATION_GRAVE,0,1,1,nil)
			if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,g1)
			end
		end
	end
Duel.RegisterFlagEffect(tp,33413522,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganesetfilter2(c)
	return  c:IsSetCard(0x6349) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function XY.maganetgfilter2(c,tp)
	return  c:IsFacedown() and c:IsControler(1-tp)
end
function XY.maganeop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(XY.maganesetfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33403522,5)) then 
		local ss=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ss>2 then ss=2 end 
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local g1=Duel.SelectMatchingCard(tp,XY.maganesetfilter2,tp,LOCATION_GRAVE,0,1,ss,nil)
		if g1:GetCount()>0 and Duel.SSet(tp,g1)~=0 then
		   local tc=g1:GetFirst()
		   while tc do 
			 local g=tc:GetColumnGroup():FilterCount(XY.maganetgfilter2,nil,tp) 
			 if g:GetCount()>0 then 
			 Duel.SendtoGrave(g,REASON_EFFECT)
			 end
			 tc=g1:GetNext()
		   end 
		   Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end   

function XY.maganethfilter3(c)
	return  c:IsSetCard(0x6349) and c:IsAbleToHand()
end
function XY.maganetrickop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1000,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,XY.maganethfilter1,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,XY.maganethfilter1,1-tp,0,LOCATION_ONFIELD,2,2,nil)
	if g2:GetCount()>0 then 
	g1:Merge(g2)
	end
	Duel.SendtoGrave(g1,REASON_EFFECT) 
Duel.RegisterFlagEffect(tp,33413523,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganespfilter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function XY.maganeop3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local ss=Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.Damage(1-tp,ss*300,REASON_EFFECT)
	if (Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(XY.maganespfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp))) and Duel.SelectYesNo(tp,aux.Stringid(33403523,2)) then 
		if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) and (not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(XY.maganespfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)) or Duel.SelectOption(tp,aux.Stringid(33403523,4),aux.Stringid(33403523,5))==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,XY.maganespfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end   

function XY.maganethfilter4(c)
	return  c:IsSetCard(0x6349) and c:IsAbleToHand()
end
function XY.maganetrickop4(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 if Duel.Draw(tp,1,REASON_EFFECT)~=0 then  
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if not  (tc:IsCode(33403520) or  tc:IsSetCard(0x6349)) then
			 Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
	 if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then  
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(tp,tc)
		Duel.BreakEffect()
		if not  (tc:IsCode(33403520) or  tc:IsSetCard(0x6349)) then
			 Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
Duel.RegisterFlagEffect(tp,33413524,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganeckfilter4(c)
	return c:IsSetCard(0x6349) or c:IsCode(33403520)
end
function XY.maganethfilter4(c)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520)) and c:IsAbleToHand()
end
function XY.maganeop4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then 
		local g=Duel.GetOperatedGroup()
		if g:IsExists(XY.maganeckfilter4,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33403524,1))
		then 
		   local g2=g:Select(tp,1,1,nil)
		   Duel.ConfirmCards(tp,g2)  
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local g3=Duel.SelectMatchingCard(tp,XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,1,nil)
		   Duel.SendtoHand(g3,nil,REASON_EFFECT)
		end
	end
end   

function XY.maganetrickop5(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	 local g3=Duel.SelectMatchingCard(1-tp,Card.IsAbleToChangeControler,1-tp,0,LOCATION_MZONE,1,1,nil)
	 if g3:GetCount()>0 and Duel.GetControl(g3,1-tp)~=0 then 
		local tc=g3:GetFirst()
		local atk=tc:GetAttack()
		if atk>0 then 
		Duel.Recover(tp,atk,REASON_EFFECT)
		Duel.Recover(1-tp,atk,REASON_EFFECT)
		end
	else
	Duel.Damage(tp,1500,REASON_EFFECT)
	end
Duel.RegisterFlagEffect(tp,33413525,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganeop5(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	 local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,2,nil)
	 if g3:GetCount()>0 and Duel.GetControl(g3,tp)~=0 then 
		local tg1=g3:GetFirst()
		local at1=tg1:GetAttack()
		local tg2=g3:GetNext()
		local at2=0
		local dam=0
		if tg2 then at2=tg2:GetAttack() end
		local at2=at2+at1
		if at2>0 then 
		Duel.Recover(tp,at2,REASON_EFFECT)
		end   
	else
	Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end  

function XY.maganebpcon6(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function XY.maganeval6(e,re,dam,r,rp,rc)
	if dam<=3000 then
		return 0
	else
		return dam
	end
end
function XY.maganetrickop6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SKIP_BP)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()~=PHASE_DRAW and Duel.GetCurrentPhase()~=PHASE_STANDBY and Duel.GetCurrentPhase()~=PHASE_MAIN1 then
		e0:SetLabel(Duel.GetTurnCount())
		e0:SetCondition(XY.maganebpcon6)
		e0:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e0:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e0,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(XY.maganeval6)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
Duel.RegisterFlagEffect(tp,33413526,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganeop6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		g1:RemoveCard(c)
	end
	if g1:GetCount()>0 then
		Duel.BreakEffect()
	end
	local ng=g1:Filter(aux.NegateAnyFilter,nil)
	local nc=ng:GetFirst()
	while nc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			nc:RegisterEffect(e3)
		end
		nc=ng:GetNext()
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end

function XY.maganeckfilter7(c)
	return  c:IsSetCard(0x6349) and not c:IsCode(33403527)
end
function XY.maganetrickop7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(33403527,2))
	local g=Duel.SelectMatchingCard(1-tp,XY.maganeckfilter7,1-tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local cd=tc:GetCode()
	if cd==33403521 then
	XY.maganetrickop1(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403522 then
	XY.maganetrickop2(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403523  then
	XY.maganetrickop3(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403524   then 
	XY.maganetrickop4(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403525 then 
	XY.maganetrickop5(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403526 then
	XY.maganetrickop6(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403528 then
	XY.maganetrickop8(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403529 then 
	XY.maganetrickop9(e,tp,eg,ep,ev,re,r,rp)
	elseif cd==33403530 then 
	XY.maganetrickop10(e,tp,eg,ep,ev,re,r,rp)
	end
Duel.RegisterFlagEffect(tp,33413527,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganethfilter7(c)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520)) and c:IsAbleToHand()
end
function XY.maganeop7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 local g=Duel.SelectMatchingCard(tp,XY.maganethfilter7,tp,LOCATION_GRAVE,0,1,2,nil)
	 if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
end

function XY.maganespfilter8(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function XY.maganetrickop8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  Duel.IsExistingMatchingCard(XY.maganespfilter8,tp,LOCATION_HAND,0,1,nil,e,tp) and  Duel.SelectYesNo(tp,aux.Stringid(33403528,0))then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,XY.maganespfilter8,tp,LOCATION_HAND,0,1,1,nil,e,tp)   
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and  Duel.IsExistingMatchingCard(XY.maganespfilter8,1-tp,LOCATION_HAND,0,1,nil,e,1-tp) and  Duel.SelectYesNo(1-tp,aux.Stringid(33403528,0))then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,XY.maganespfilter8,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)	   
		Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(XY.maganeactcon)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
Duel.RegisterFlagEffect(tp,33413528,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
function XY.maganeactcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function XY.maganethfilter8(c)
	return  c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function XY.maganespfilter8(c,e,tp)
	return   c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function XY.maganeop8(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(XY.maganethfilter8,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
	   local b2=Duel.IsExistingMatchingCard(XY.maganespfilter8,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	   if not (b1 or b2)  then return end 
	   if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(33400818,6),aux.Stringid(33400818,7))
	   elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(33400818,6))
	   else op=Duel.SelectOption(tp,aux.Stringid(33400818,7))+1 end
	   if op==0 then			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,XY.maganethfilter8,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)  
				Duel.ConfirmCards(1-tp,g)   
			end
		else
			local ct=1
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then ct=2 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,XY.maganespfilter8,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,ct,nil,e,tp)
			if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,nil,tp,tp,false,false,POS_FACEUP)
			end
		end
end

function XY.maganefilter9(c)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520)) and c:IsAbleToHand()
end
function XY.maganetrickop9(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>=4 then
		local g=Duel.GetDecktopGroup(tp,4)
		Duel.ConfirmCards(1-tp,g)
		Duel.SortDecktop(1-tp,tp,4)
	end
	if cm2>=4 then
		  local g=Duel.GetDecktopGroup(1-tp,4)
		  Duel.ConfirmCards(1-tp,g)
		  Duel.SortDecktop(1-tp,1-tp,4)   
	end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	local tg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	Duel.ConfirmCards(1-tp,tg)
Duel.RegisterFlagEffect(tp,33413529,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganeop9(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	local tg2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	tg:Merge(tg2)
	Duel.ConfirmCards(tp,tg)
	Duel.Draw(tp,2,REASON_EFFECT)
end

function XY.maganethfilter0(c,tp)
	local ss=0
	if c:IsCode(33403521) and Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403522) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403523) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403524) and Duel.IsPlayerCanDraw(tp,3) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403525) and (Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403526) and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403527) and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403528) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0  then
	ss=1
	end
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if c:IsCode(33403529) and cm1>=4 and  cm2>=4 and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0 then
	ss=1
	end
	if c:IsCode(33403530) and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0  then
	ss=1
	end
	return  ss==1
end
function XY.maganeckfilter10(c,tp)
	local ss=0
	if c:IsCode(33403521) and Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
	ss=1
	end
	if c:IsCode(33403522) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then
	ss=1
	end
	if c:IsCode(33403523) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
	ss=1
	end
	if c:IsCode(33403524) and Duel.IsPlayerCanDraw(tp,3) then
	ss=1
	end
	if c:IsCode(33403525) and (Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0) then
	ss=1
	end
	if c:IsCode(33403526) and Duel.IsPlayerCanDraw(tp,1) then
	ss=1
	end
	if c:IsCode(33403527) and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,nil) then
	ss=1
	end
	if c:IsCode(33403528)  then
	ss=1
	end
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if c:IsCode(33403529) and cm1>=4 and  cm2>=4 and Duel.IsPlayerCanDraw(tp,1) then
	ss=1
	end
	if c:IsCode(33403530)  then
	ss=1
	end
	return  ss==1
end
function XY.maganetrickop10(e,tp,eg,ep,ev,re,r,rp)
   if not  Duel.IsExistingMatchingCard(XY.maganeckfilter10,1-tp,LOCATION_GRAVE,0,1,nil,1-tp) then return end
   local c=e:GetHandler()
   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33403530,1))
   local g=Duel.SelectMatchingCard(1-tp,XY.maganeckfilter10,1-tp,LOCATION_GRAVE,0,1,1,nil,1-tp)
   if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc:IsCode(33403521)  then
	  XY.maganere1(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403522)  then
	 XY.maganere2(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403523) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
	XY.maganere3(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403524) and Duel.IsPlayerCanDraw(tp,3) then
	XY.maganere4(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403525) and (Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0) then
	 XY.maganere5(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403526) and Duel.IsPlayerCanDraw(tp,1) then
	XY.maganere6(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403527) and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,nil) then
	 XY.maganere7(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403528)  then
	XY.maganere8(e,1-tp,eg,ep,ev,re,r,rp)
	end
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if tc:IsCode(33403529) and cm1>=4 and  cm2>=4 and Duel.IsPlayerCanDraw(tp,1) then
	 XY.maganere9(e,1-tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsCode(33403530)  then
	 XY.maganere10(e,1-tp,eg,ep,ev,re,r,rp)
	end  
   end 
Duel.RegisterFlagEffect(tp,33413530,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganeop10(e,tp,eg,ep,ev,re,r,rp)
 if   Duel.IsExistingMatchingCard(XY.maganeckfilter10,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(33403530,4)) then
   local c=e:GetHandler()
   local g=Duel.GetMatchingGroup(XY.maganeckfilter10,tp,LOCATION_GRAVE,0,nil,tp)
   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33403530,1))
   local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
   if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
		if tc:IsCode(33403521)  then
		  XY.maganere1(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403522)  then
		 XY.maganere2(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403523) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
		XY.maganere3(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403524) and Duel.IsPlayerCanDraw(tp,3) then
		XY.maganere4(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403525) and (Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0) then
		 XY.maganere5(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403526) and Duel.IsPlayerCanDraw(tp,1) then
		XY.maganere6(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403527) and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_GRAVE,0,1,nil) then
		 XY.maganere7(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403528)  then
		XY.maganere8(e,tp,eg,ep,ev,re,r,rp)
		end
		cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if tc:IsCode(33403529) and cm1>=4 and  cm2>=4 and Duel.IsPlayerCanDraw(tp,1) then
		 XY.maganere9(e,tp,eg,ep,ev,re,r,rp)
		end
		if tc:IsCode(33403530)  then
		 XY.maganere10(e,tp,eg,ep,ev,re,r,rp)
		end  
		tc=sg:GetNext()
	  end
   end 
 end
end

function XY.maganere1(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
Duel.RegisterFlagEffect(tp,33413521,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganere2(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
	end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
Duel.RegisterFlagEffect(tp,33413522,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganerefilter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function XY.maganere3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
	   local ss=Duel.SendtoGrave(g,REASON_EFFECT)
	   local sg=Duel.GetOperatedGroup()
	   Duel.Damage(1-tp,ss*300,REASON_EFFECT)
	   if not sg:IsExists(XY.maganerefilter3,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.SelectYesNo(tp,aux.Stringid(33403523,6)) then 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,2,nil,TYPE_SPELL+TYPE_TRAP)
		if g2:GetCount()>0 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	   end
	end
Duel.RegisterFlagEffect(tp,33413523,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganere4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,3,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(p)
	end
Duel.RegisterFlagEffect(tp,33413524,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganere5(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then 
		Duel.Damage(tp,2000,REASON_EFFECT)
	 elseif Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) then 
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
		local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,3,nil)
		if g3:GetCount()>0 and Duel.GetControl(g3,tp)~=0 then 
			local tc1=g3:GetFirst()
			local at1=tc1:GetAttack()
			local tc2=g3:GetNext()
			while tc2 do 
				at1=at1+tc2:GetAttack() 
				tc2=g3:GetNext()
			end
			if at1>0 then 
				Duel.Recover(tp,at1,REASON_EFFECT)
			end   
		end
	end
	Duel.RegisterFlagEffect(tp,33413525,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganere6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SKIP_BP)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()~=PHASE_DRAW and Duel.GetCurrentPhase()~=PHASE_STANDBY and Duel.GetCurrentPhase()~=PHASE_MAIN1 then
		e0:SetLabel(Duel.GetTurnCount())
		e0:SetCondition(XY.maganebpcon6)
		e0:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e0:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(XY.maganereactlimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
Duel.RegisterFlagEffect(tp,33413526,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
Duel.Draw(tp,1,REASON_EFFECT)
end
function XY.maganereactlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and not re:GetHandler():IsCode(33403520)
end

function XY.maganere7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,XY.maganethfilter7,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,33413527,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganereefilter(e,re,tp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function XY.maganere8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		  --immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(XY.maganereefilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(2*tc:GetAttack())
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(2*tc:GetDefense())
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(XY.maganeactcon)
	e4:SetValue(1)
	if Duel.GetTurnPlayer()==tp  then
		e4:SetLabel(Duel.GetTurnCount())
		e4:SetCondition(XY.maganebpcon6)
		e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e4,tp)
	Duel.RegisterFlagEffect(tp,33413528,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganere9(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>=4 then
		local g=Duel.GetDecktopGroup(tp,4)
		Duel.ConfirmCards(tp,g)
		Duel.SortDecktop(tp,tp,4)
	end
	if cm2>=4 then
		  local g=Duel.GetDecktopGroup(1-tp,4)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,4)   
	end
	local tg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	local tg2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	tg:Merge(tg2)
	Duel.ConfirmCards(tp,tg)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,33413529,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end

function XY.maganere10(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,33403521)>=9 then 
		Duel.RegisterFlagEffect(tp,33433530,0,0,0)
	end
	Duel.RegisterFlagEffect(tp,33413530,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end





