--刹那芳华 月祭
function c10700735.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700735,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1,10700735)
	e1:SetCondition(c10700735.spcon)
	e1:SetTarget(c10700735.sptg)
	e1:SetOperation(c10700735.spop)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700735,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,10700736)
	e2:SetCondition(c10700735.drcon)
	e2:SetTarget(c10700735.drtg)
	e2:SetOperation(c10700735.drop)
	c:RegisterEffect(e2)		
end
function c10700735.spcon(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return h1==h2
end
function c10700735.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10700735.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		  Duel.BreakEffect()
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		  e1:SetValue(-500)
		  Duel.RegisterEffect(e1,tp)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_UPDATE_DEFENSE)
		  Duel.RegisterEffect(e2,tp)
	  end
end
function c10700735.drcon(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return h1<h2
end
function c10700735.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700735.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end 
		Duel.BreakEffect()  
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,g)
		while tc do
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_PUBLIC)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		  tc:RegisterEffect(e2)
		  tc:RegisterFlagEffect(10700735,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10700735,2))
		  tc=g:GetNext()
		end
		  local e3=Effect.CreateEffect(e:GetHandler())
		  e3:SetType(EFFECT_TYPE_FIELD)
		  e3:SetCode(EFFECT_CANNOT_SUMMON)
		  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		  e3:SetTargetRange(1,0)
		  e3:SetTarget(c10700735.sumlimit)
		  e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		  Duel.RegisterEffect(e3,tp)
		  local e4=e3:Clone()
		  e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		  Duel.RegisterEffect(e4,tp)
		  local e5=e3:Clone()
		  e5:SetCode(EFFECT_CANNOT_ACTIVATE)
		  e5:SetValue(c10700735.aclimit)
		  Duel.RegisterEffect(e5,tp)
end
function c10700735.sumlimit(e,c)
	return c:GetFlagEffect(10700735)>0 and not c:IsSetCard(0x7cc) and c:IsPublic()
end
function c10700735.aclimit(e,re,tp)
	return re:GetHandler():GetFlagEffect(10700735)>0 and not re:GetHandler():IsSetCard(0x7cc) and re:GetHandler():IsPublic()
end