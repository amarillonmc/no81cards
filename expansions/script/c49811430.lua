--よんめんたいの晶甲羅
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)	
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--toPzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(s.pencon)
	e3:SetTarget(s.pentg)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
	--selecteffect
	local e4=Effect.CreateEffect(c)	
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()
end
function s.hspfilter(c,tp,sc)
	return c:IsType(TYPE_NORMAL) and c:IsLevel(4) and c:IsRace(RACE_AQUA) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
		and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.hspcon(e,c)
	if c==nil then return true end
	return c:IsFacedown() and Duel.CheckReleaseGroupEx(c:GetControler(),s.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
function s.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function s.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if g:GetFirst():GetLocation()==LOCATION_HAND and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1))then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
				end
			end
		end
	end
end
function s.penfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.penfilter,1,c) and not eg:IsContains(c) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,4042268) and Duel.GetFlagEffect(tp,id)==0
	local b2=Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,37313348) and Duel.IsAbleToEnterBP() and Duel.GetFlagEffect(tp,id+1)==0
	if chk==0 then return c:IsDestructable() and (b1 or b2) end
	if b1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.attarget(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local b1=Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,4042268) and Duel.GetFlagEffect(tp,id)==0
		local b2=Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,37313348) and Duel.IsAbleToEnterBP() and Duel.GetFlagEffect(tp,id+1)==0
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,4))
		elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(id,5))+1
		else return end
		if op==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(s.sspcon)
			e1:SetOperation(s.sspop)
			if Duel.GetCurrentPhase()<=PHASE_STANDBY then
				e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_STANDBY)
			end
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(s.attarget)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.desfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function s.sspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		if ft>2 then ft=2 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
		if g:GetCount()~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end