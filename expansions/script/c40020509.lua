--创界神 乌拉诺斯
local s,id=GetID()
s.named_with_Grandwalker=1
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_SZONE, 0)
	e2:SetTarget(s.acttarget)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)
end
function s.acttarget(e, c)
	return c:IsType(TYPE_TRAP) 
	   and s.HighEvo(c)
end

function s.filter(c)
	return c:IsFacedown() and s.HighEvo(c) and c:IsType(TYPE_TRAP) 
end

function s.setfilter(c)
	return c:IsType(TYPE_TRAP)  and c:IsSSetable()
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFacedown() then return end

	Duel.ChangePosition(tc,POS_FACEUP)

	local te=tc:GetActivateEffect()

	if te then

		local teg,tep,tev,tre,tr,trp = nil,tp,0,nil,0,0
		

		local tg=te:GetTarget()
		if tg then

			tg(te,tp,teg,tep,tev,tre,tr,trp,1)
		end
		
		local op=te:GetOperation()
		if op then
			tc:CreateEffectRelation(te)
			op(te,tp,teg,tep,tev,tre,tr,trp)
			tc:ReleaseEffectRelation(te)
		end
	end
	
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			if Duel.SSet(tp,sg)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end


function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end


function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end


function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	

	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end


	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end

