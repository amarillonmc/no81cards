--暗月古神 尤格-萨隆
function c51924010.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--pendulum effect
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c51924010.drcon)
	e1:SetTarget(c51924010.drtg)
	e1:SetOperation(c51924010.drop)
	c:RegisterEffect(e1)
	--moster effect
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c51924010.sprcon)
	e2:SetTarget(c51924010.sprtg)
	e2:SetOperation(c51924010.sprop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c51924010.efilter)
	c:RegisterEffect(e3)
	--dice
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c51924010.dicetg)
	e4:SetOperation(c51924010.diceop)
	c:RegisterEffect(e4)
	if not c51924010.global_check then
		c51924010.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c51924010.checkcon)
		ge1:SetOperation(c51924010.checkop)
		Duel.RegisterEffect(ge1,0)
	end
c51924010.toss_dice=true
end
function c51924010.ctfilter(c)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsSetCard(0x3256)
end
function c51924010.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51924010.ctfilter,1,nil)
end
function c51924010.checkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c51924010.ctfilter,nil)
	for tc in aux.Next(sg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),51924010,RESET_PHASE+PHASE_END,0,1)
	end
end
function c51924010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,51924010)>0
end
function c51924010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,51924010)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c51924010.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,51924010)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c51924010.rlcheck(g,sc,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c51924010.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil,c,tp)
	return g:CheckSubGroup(c51924010.rlcheck,3,3,c,tp)
end
function c51924010.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c51924010.rlcheck,true,3,3,c,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c51924010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c51924010.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		return true
	elseif te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetHandler()
		if ec:IsType(TYPE_LINK) then
			return ec:GetLink()<lv
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
function c51924010.dicetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c51924010.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c51924010.diceop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 then
		local bk=true
		for p=tp,1-tp,1-tp-tp do
			local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
			if 6-ct>0 then
				if bk then
					bk=false
					Duel.BreakEffect()
				end
				Duel.Draw(p,6-ct,REASON_EFFECT)
			end
		end
	elseif dc==2 then
		Duel.Draw(tp,3,REASON_EFFECT)
	elseif dc==3 then
		for p=tp,1-tp,1-tp-tp do
			local ft=Duel.GetMZoneCount(p)
			local g=Duel.GetMatchingGroup(c51924010.spfilter,p,LOCATION_DECK,0,nil,e,p)
			if ft<=0 or g:GetCount()==0 then return end
			if Duel.IsPlayerAffectedByEffect(p,59822133) then ft=1 end
			local ct=math.min(#g,ft)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(p,aux.TRUE,false,ct,ct)
			for tc in aux.Next(sg) do
				if Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP_ATTACK) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(51924010,0))
				end
				Duel.SpecialSummonComplete()
			end
		end
	elseif dc==4 then
		if Duel.GetMZoneCount(tp)<3 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,3,3,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.GetControl(g,tp)
		end
	elseif dc==5 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		local c=e:GetHandlerPlayer()
		local og=Duel.GetOperatedGroup()
		local ag=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if c:IsRelateToEffect(e) and c:IsFaceup() and #ag>0 then
			local atk=ag:GetSum(Card.GetBaseAttack)
			local def=ag:GetSum(Card.GetBaseDefense)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(def)
			c:RegisterEffect(e2)
		end
	elseif dc==6 then
		for ct=1,30 do
			local d1,d2=Duel.TossDice(tp,1,1)
			if d1<d2 then
				Duel.Damage(tp,1000,REASON_EFFECT)
			elseif d1>d2 then
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
			if ct==30 then Duel.SetLP(1-tp,0) end
		end
	end
end
