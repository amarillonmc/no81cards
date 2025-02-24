if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=SNNM.ScreemEquips(c,EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetLabelObject(g)
		ge1:SetOperation(s.MergedDelayEventCheck1)
		Duel.RegisterEffect(ge1,0)
		local f=Duel.Overlay
		Duel.Overlay=function(oc,og)
			local op=f(oc,og)
			g:Merge(Group.__add(og,og):Filter(s.cfilter2,nil))
			if #g>0 and Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
				local _eg=g:Clone()
				Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,Effect.GlobalEffect(),0,0,0,0)
				g:Clear()
			end
			return op
		end
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.MergedDelayEventCheck2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.cfilter1(c)
	local typ,lv=c:GetPreviousTypeOnField(),c:GetPreviousLevelOnField()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and typ&0x1==0x1 and lv>0 and lv<3
end
function s.cfilter2(c)
	return c:IsLevel(1,2) and c:IsFaceup()
end
function s.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg:Filter(s.cfilter1,nil))
	if #g>0 and Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToRemove() and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) end
	local ct=e:GetHandler():GetFlagEffectLabel(53762000) or 0
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	e:GetHandler():ResetFlagEffect(53762000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function s.spfilter(c,e,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(2)
	c:RegisterEffect(e1)
	local res=c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,tp)
	e1:Reset()
	return res
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=g:Filter(aux.NOT(Card.IsPublic),nil)
	local g1=Group.__sub(g,g2):Filter(s.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (#g2>0 or #g1>0) and Duel.IsPlayerCanSpecialSummon(1-tp) and not Duel.IsPlayerAffectedByEffect(1-tp,63060238) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,1-tp,tp,false,false,POS_FACEUP) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(2)
		tc:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
		if c:IsRelateToEffect(e) and c:CheckEquipTarget(tc) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Equip(tp,c,tc)
		end
	end
end
