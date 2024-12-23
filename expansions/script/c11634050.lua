--宇宙摇曳龙
local cm,m=GetID()

function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x200)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.pentg)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(0x200)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end

function cm.penfilter(c)
	return not c:IsType(TYPE_PENDULUM) and c:IsType(0x1) and not c:IsForbidden()
end

function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.penfilter,tp,0x02,0,1,nil) and (Duel.CheckLocation(tp,0x200,0) or Duel.CheckLocation(tp,0x200,1)) end
end

function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,0x200,0) or Duel.CheckLocation(tp,0x200,1)) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.penfilter,tp,0x02,0,1,1,nil):GetFirst()
	if tc then
		local c=e:GetHandler()
		if not tc:IsType(TYPE_PENDULUM) then
			local eP=Effect.CreateEffect(c)
			eP:SetType(EFFECT_TYPE_SINGLE)
			eP:SetCode(EFFECT_ADD_TYPE)
			eP:SetValue(TYPE_PENDULUM)
			eP:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			eP:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(eP)
			local ePS=Effect.CreateEffect(c)
			ePS:SetDescription(1163)
			ePS:SetType(EFFECT_TYPE_FIELD)
			ePS:SetCode(EFFECT_SPSUMMON_PROC_G)
			ePS:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ePS:SetRange(LOCATION_PZONE)
			ePS:SetCondition(aux.PendCondition())
			ePS:SetOperation(aux.PendOperation())
			ePS:SetValue(SUMMON_TYPE_PENDULUM)
			ePS:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(ePS)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(tc:GetLevel()+1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			tc:RegisterEffect(e2)
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function cm.tgsfilter(c,e,tp)
	return c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.mzctcheck(nil,tp))
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x200,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x200)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x200)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local tc=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x200,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.mzctcheck(nil,tp)
		local b2=tc:IsAbleToHand()
		if b1 or b2 then
			if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.HintSelection(Group.FromCards(tc))
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				if tc:IsLocation(0x02) then Duel.ConfirmCards(1-tp,tc) end
			end
		end
	end
end