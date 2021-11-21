--教团的翼骑士 韦因
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104210)
function cm.initial_effect(c)
	local e0,e0_1=rkch.PenTri(c,m)
	e0:SetCondition(cm.con)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	local e1=rkch.GainEffect(c,m)
	local e2=rsef.QO(c,EVENT_FREE_CHAIN,{m,2},{1},"rm",nil,LOCATION_MZONE,rkch.gaincon(m),cm.eqcost,rsop.target(cm.eqfilter,"rm",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.reop)
	local e3=rsef.I(c,{m,3},{1,m+1},"dr",EFFECT_FLAG_PLAYER_TARGET,LOCATION_HAND,nil,cm.cost,rsop.target(1,"dr"),cm.drop)
	local e4=rkch.MonzToPen(c,m,EVENT_RELEASE,nil)
end
cm.dff=true
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end
function cm.eqfilter(c,ec)
	return c:IsAbleToRemove()
end
function cm.reop(e,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			tc:RegisterFlagEffect(m+10,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SPSUMMON_CONDITION)
			e1:SetValue(aux.FALSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			e2:SetCondition(aux.TRUE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.drop(e,tp)
	if Duel.Draw(tp,1,REASON_EFFECT)<=0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0xccd) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_DRAW)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetOperation(cm.regop)
		e3:SetLabelObject(e1)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetLabelObject(e2)
		Duel.RegisterEffect(e4,tp)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsSummonPlayer(tp) and tc:IsSummonType(SUMMON_TYPE_ADVANCE) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end