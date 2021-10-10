--联合行动-多元作战
function c79029232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029232)
	e1:SetCondition(c79029232.accon)
	e1:SetOperation(c79029232.acop)
	c:RegisterEffect(e1)
	if not c79029232.global_check then
		c79029232.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON)
		ge1:SetOperation(c79029232.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c79029232.checkfilter(c,tp,typ)
	return not c:IsSetCard(0xa900) 
end
function c79029232.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c79029232.checkfilter,1,nil) then
	Duel.RegisterFlagEffect(rp,79029232,RESET_PHASE+PHASE_END,0,1)
end
end
function c79029232.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,79029232)==0
end
function c79029232.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029232.splimit)
	Duel.RegisterEffect(e1,tp)
	--Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetLabel(TYPE_FUSION)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c79029232.effcon)
	e1:SetTarget(c79029232.futg)
	e1:SetOperation(c79029232.fuop)
	Duel.RegisterEffect(e1,tp)
	--Synchro
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetLabel(TYPE_SYNCHRO)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c79029232.effcon)
	e2:SetTarget(c79029232.sytg)
	e2:SetOperation(c79029232.syop)
	Duel.RegisterEffect(e2,tp)
	--Xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabel(TYPE_XYZ)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c79029232.effcon)
	e3:SetTarget(c79029232.xyztg)
	e3:SetOperation(c79029232.xyzop)
	Duel.RegisterEffect(e3,tp)
	--Ritual
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetLabel(TYPE_RITUAL)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetCondition(c79029232.effcon)
	e4:SetTarget(c79029232.ritg)
	e4:SetOperation(c79029232.riop)
	Duel.RegisterEffect(e4,tp)
	--Pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetLabel(TYPE_PENDULUM)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetCondition(c79029232.effcon)
	e5:SetTarget(c79029232.petg)
	e5:SetOperation(c79029232.peop)
	Duel.RegisterEffect(e5,tp)
	--Link
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCategory(CATEGORY_TOEXTRA)
	e6:SetLabel(TYPE_LINK)
	e6:SetReset(RESET_PHASE+PHASE_END)
	e6:SetCondition(c79029232.effcon)
	e6:SetOperation(c79029232.liop)
	Duel.RegisterEffect(e6,tp)
	--8000
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetReset(RESET_PHASE+PHASE_END)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCost(aux.bfgcost)
	e7:SetCondition(c79029232.accon1)
	e7:SetOperation(c79029232.loop)
	c:RegisterEffect(e7)
end
function c79029232.accon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,790292329)~=0
	  and  Duel.GetFlagEffect(tp,7902923299)~=0
	  and  Duel.GetFlagEffect(tp,79029232999)~=0
	  and  Duel.GetFlagEffect(tp,790292329999)~=0
	  and  Duel.GetFlagEffect(tp,7902923299999)~=0
	  and  Duel.GetFlagEffect(tp,79029232999999)~=0
end
function c79029232.loop(e,tp,eg,ep,ev,re,r,rp)
	 local lp=Duel.GetLP(1-tp)
	 Duel.SetLP(1-tp,lp-8000)
end
function c79029232.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900) and (c:IsLocation(LOCATION_EXTRA) or c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end
function c79029232.cfilter(c,tp,typ)
	return c:IsFaceup() and c:IsType(typ) and c:IsSetCard(0xa900) and c:IsControler(tp) and (c:GetSummonLocation()==LOCATION_HAND or c:GetSummonLocation()==LOCATION_EXTRA)
end
function c79029232.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029232.cfilter,1,nil,tp,e:GetLabel())
end
function c79029232.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,790292329)==0 end
end
function c79029232.fuop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79029232,0)) then
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,790292329,RESET_PHASE+PHASE_END,0,1)
end
end
function c79029232.spfilter(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029232.sytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c79029232.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,7902923299)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c79029232.syop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79029232,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c79029232.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,7902923299,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029232.xyzfil(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xa900) 
end
function c79029232.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c79029232.xyzfil,nil)
	if chk==0 then return g:GetSum(Card.GetOverlayCount)>0 and Duel.GetFlagEffect(tp,79029232999)==0 end
end
function c79029232.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79029232,2)) then
	local g=eg:Filter(c79029232.xyzfil,nil)
	local x=g:GetSum(Card.GetOverlayCount)*500
	Duel.Damage(1-tp,x,REASON_EFFECT) 
	Duel.RegisterFlagEffect(tp,79029232999,RESET_PHASE+PHASE_END,0,1)  
end
end
function c79029232.thfilter(c,e,tp)
	return (c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d) or c:IsSetCard(0xa90f)) and c:IsAbleToHand()
end
function c79029232.ritg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029232.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,790292329999)==0 end
end
function c79029232.riop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79029232,3)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c79029232.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	Duel.RegisterFlagEffect(tp,790292329999,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029232.pefil(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa900) and c:IsControler(tp)
end
function c79029232.tefilter(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsAbleToExtra()
end
function c79029232.petg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029232.tefilter,tp,LOCATION_DECK,0,1,nil,e,tp)and Duel.GetFlagEffect(tp,7902923299999)==0 end
end
function c79029232.peop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c79029232.pefil,nil,tp)
	local x=g:GetCount()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79029232,4)) then
	local g=Duel.SelectMatchingCard(tp,c79029232.tefilter,tp,LOCATION_DECK,0,1,x,nil,e,tp)
	Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,7902923299999,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029232.lifilter(c,tp,typ)
	return c:IsSetCard(0xa900) and c:IsControler(tp) and c:IsType(TYPE_LINK) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c79029232.liop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,79029232999999)~=0 then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79029232,5)) then
	Duel.RegisterFlagEffect(tp,79029232999999,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local g=eg:Filter(c79029232.lifilter,nil,tp,e:GetLabel())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(79029232,6))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetReset(RESET_EVENT+RESETS_STANDARD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(1)
	tc:RegisterEffect(e9)
		tc=g:GetNext()
	end
end
end

