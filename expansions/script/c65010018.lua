--斩尽杀绝凶猛龙
function c65010018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c65010018.matfilter1,c65010018.matfilter,2,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c65010018.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c65010018.sprcon)
	e2:SetOperation(c65010018.sprop)
	c:RegisterEffect(e2)
	--spsummonsuccess
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,65010018)
	e3:SetOperation(c65010018.op)
	c:RegisterEffect(e3)
end
function c65010018.op(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetLP(1-tp)/2
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		if c:RegisterEffect(e1)~=0 then
			Duel.SetLP(1-tp,atk)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(c65010018.damval)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e2=e3:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetLabel(atk)
		e4:SetOperation(c65010018.reop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c65010018.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c65010018.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65010018)
	Duel.Recover(1-tp,e:GetLabel(),REASON_EFFECT)
end
function c65010018.matfilter1(c)
	return c:IsFusionType(TYPE_EFFECT) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c65010018.matfilter(c)
	return c:IsFusionType(TYPE_EFFECT)
end
function c65010018.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c65010018.matfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and c:IsType(TYPE_EFFECT)
end
function c65010018.spfilter1(c,tp,g)
	return c:GetSummonLocation()==LOCATION_EXTRA and g:IsExists(c65010018.spfilter2,1,c,tp,c,g)
end
function c65010018.spfilter2(c,tp,mc,g)
	local gg=Group.FromCards(c,mc)
	return g:IsExists(c65010018.spfilter3,1,gg,tp,mc,c)
end
function c65010018.spfilter3(c,tp,mc,gc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc,gc))>0
end
function c65010018.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65010018.matfil,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65010018.spfilter1,1,nil,tp,g)
end
function c65010018.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65010018.matfil,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c65010018.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c65010018.spfilter2,1,1,mc,tp,mc,g)
	local gc=g2:GetFirst()
	local gg=Group.FromCards(mc,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=g:FilterSelect(tp,c65010018.spfilter3,1,1,gg,tp,mc,gc)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end