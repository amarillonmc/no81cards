--さんかくそうすいの晶甲羅
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
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_DESTROY)
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
	--conpeffect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(s.pcon)
	e4:SetTarget(s.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(s.discon)
	e6:SetOperation(s.disop)
	c:RegisterEffect(e6)
end
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()
end
function s.hspfilter(c,tp,sc)
	return c:IsType(TYPE_NORMAL) and c:IsLevel(5) and c:IsRace(RACE_AQUA) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
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
			if g:GetFirst():GetLocation()==LOCATION_HAND and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(id,1))then
				Duel.BreakEffect()
				if Duel.Draw(tp,2,REASON_EFFECT)==2 then
					Duel.ShuffleHand(tp)
					Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
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
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,11714098)
end
function s.indtg(e,c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDestructable() and rp==1-tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,96981563) and Duel.GetFlagEffect(tp,id)==0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then		
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_CARD,0,id)
			local rc=re:GetHandler()
			if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end