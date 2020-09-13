--天使-飓风骑士-天际疾驰者
local m=33400852
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--move
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.mvtg)
	e2:SetOperation(cm.mvop)
	c:RegisterEffect(e2)
 --actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.actcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(cm.cfilter))
	e4:SetCondition(cm.actcon)
	c:RegisterEffect(e4)
 --disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.actcon) 
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
--destroy 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,5))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.destg)
	e6:SetOperation(cm.desop)
	c:RegisterEffect(e6)
	--tg
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetOperation(cm.tgop)
	c:RegisterEffect(e7)
	 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(cm.backon)
	e9:SetOperation(cm.backop)
	c:RegisterEffect(e9)
end
function cm.mvfilter1(c)
	return c:IsFaceup() 
end
function cm.mvfilter2(c,tp)
	return c:IsFaceup()  and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(cm.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function cm.mvfilter3(c)
	return c:IsFaceup()  and c:GetSequence()<5
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
 local b1=Duel.IsExistingMatchingCard(cm.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local b2=Duel.IsExistingMatchingCard(cm.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return   b1 or b2 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
   local b1=Duel.IsExistingMatchingCard(cm.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
   local b2=Duel.IsExistingMatchingCard(cm.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
  if not (b1 or b2)  then return end 
  if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
   if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local g=Duel.SelectMatchingCard(tp,cm.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(g:GetFirst(),nseq)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local g1=Duel.SelectMatchingCard(tp,cm.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local g2=Duel.SelectMatchingCard(tp,cm.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
	end
end
end

function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa341) and c:IsControler(tp)
end
function cm.ckfilter2(c,tp)
	return c:IsFaceup()  and c:IsControler(tp)
end
function cm.actcon(e)
   local c=Duel.GetAttackTarget()
	if not c then return false end
	local seq1=aux.MZoneSequence(c:GetSequence())
	local tc=Duel.GetAttacker()
	if not tc then return false end
	local seq2=aux.MZoneSequence(tc:GetSequence())
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and cm.cfilter(c,tp) and seq1==4-seq2
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	local dc=4-tc:GetSequence()
	if tc:IsControler(tp) then
	tc=Duel.GetAttacker() 
	dc=dc 
	end
	c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(cm.discon2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetCondition(cm.discon2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(0,LOCATION_ONFIELD)
			e4:SetTarget(cm.distg2)
			e4:SetReset(RESET_PHASE+PHASE_BATTLE)
			e4:SetLabel(dc)
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(cm.disop2)
			e5:SetReset(RESET_PHASE+PHASE_BATTLE)
			e5:SetLabel(dc)
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(0,LOCATION_ONFIELD)
			e6:SetTarget(cm.distg2)
			e6:SetReset(RESET_PHASE+PHASE_BATTLE)
			e6:SetLabel(dc)
			Duel.RegisterEffect(e6,tp)
end
function cm.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function cm.distg2(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return  aux.GetColumn(c,tp)==seq
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	 if re:IsActiveType(TYPE_MONSTER) then seq=aux.MZoneSequence(seq) end
	if   rp==1-tp and seq==4-tseq then
		Duel.NegateEffect(ev)
	end
end

function cm.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa341) and c:IsType(TYPE_FUSION)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,0,1,2,nil) 
end
function cm.seqfilter(c,seq1,seq2)
local seq=c:GetSequence()
 if c:IsType(TYPE_MONSTER) then seq=aux.MZoneSequence(c:GetSequence()) end
		return (4-seq>seq1 and 4-seq<seq2 ) or c:IsType(TYPE_FIELD)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 then return end
	local cc=sg:GetCount()
	local tc1=sg:GetFirst()
	local tc2
	local tg2
	if cc>1 then
	 tc2=sg:GetNext() 
	 tg2=tc2:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	end
	local tg1=tc1:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	 if cc==1 then   
		Duel.Destroy(tg1,REASON_EFFECT)   
	else	 
		tg1:Merge(tg2)
		local seq1=tc1:GetSequence()
		local seq2=tc2:GetSequence()
		if seq1>seq2 then seq1,seq2=seq2,seq1 end 
		local tg3=Duel.GetMatchingGroup(cm.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq1,seq2)
		tg1:Merge(tg3)
		Duel.Destroy(tg1,REASON_EFFECT)   
	end
end

function cm.thfilter1(c)
	return  c:IsCode(33400850,33400851)  and c:IsAbleToHand()
end
function cm.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(Card.IsCode,1,nil,33400850) then res=res+0x1 end
	if g:IsExists(Card.IsCode,1,nil,33400851) then res=res+0x2 end
	return res~=0x1 and res~=0x2 
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then 
	local g=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local g1=g:SelectSubGroup(tp,cm.check,false,1,2)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
	end
end

function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:GetFlagEffect(33400850)>0 and 33400850) or (c:GetFlagEffect(33400851)>0 and 33400851)) and c:GetOriginalCode()==33400852
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(33400850)>0 then 
	c:SetEntityCode(33400850) 
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(33400850,0,0)
	c:ResetFlagEffect(33400850)
	end
	if c:GetFlagEffect(33400851)>0 then 
	c:SetEntityCode(33400851) 
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(33400851,0,0)
	c:ResetFlagEffect(33400851)
	end
end