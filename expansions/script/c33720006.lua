--人靠衣装
function GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end
local s,id=GetID()
function s.initial_effect(c)
	--Special 1 monster from hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function s.spfilter(c,e,tp,lv,rc,att)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and not c:IsForbidden() and c:IsLevelAbove(lv+1) and c:IsRace(rc) and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft2=ft2-1 end
	if chk==0 then return ft1>0 and ft2>0 and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if not tg or not tg:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft1<=0 or ft2<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tg:GetLevel(),tg:GetRace(),tg:GetAttribute())
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		if Duel.Damage(1-tp,math.abs(tg:GetLevel()-sg:GetFirst():GetLevel())*500,REASON_EFFECT)>0 and Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)>0 and Duel.Equip(tp,tg,sg:GetFirst(),true) then
			tg:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			e1:SetLabelObject(sg:GetFirst())
			tg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EVENT_DESTROYED)
			e2:SetCondition(s.tgcon)
			e2:SetOperation(s.tgop)
			e2:SetReset(RESET_EVENT+RESET_TOFIELD+RESET_TURN_SET)
			tg:RegisterEffect(e2)
			--special summon
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetCode(EVENT_LEAVE_FIELD_P)
			e4:SetOperation(s.eqcheck)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			sg:GetFirst():RegisterEffect(e4)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EVENT_DESTROYED)
			e3:SetCondition(s.spcon)
			e3:SetOperation(s.spop)
			e3:SetLabelObject(e4)
			e3:SetReset(RESET_EVENT+RESET_TOFIELD+RESET_TURN_SET)
			sg:GetFirst():RegisterEffect(e3)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.tgcon(e)
	local c=e:GetHandler()
	return c:GetPreviousLocation()==LOCATION_SZONE and c:GetPreviousEquipTarget()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetPreviousEquipTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function s.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup():Filter(s.spfilter1,nil)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function s.spcon(e)
	local c=e:GetHandler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c:GetPreviousLocation()==LOCATION_MZONE
end
function s.spfilter1(c)
	return c:GetFlagEffect(id)>0
end
function s.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	local g=e:GetLabelObject():GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,s.spfilter2,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(function(e,c) return c==sg:GetFirst() end)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end