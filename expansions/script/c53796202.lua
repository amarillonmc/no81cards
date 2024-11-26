local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.scon)
	e2:SetCost(s.scost)
	e2:SetTarget(s.stg)
	e2:SetOperation(s.sop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS,g)
	if not s.global_check then
		s.global_check=true
		local f1=Card.IsSummonType
		Card.IsSummonType=function(sc,type)
			if sc:GetFlagEffect(id)>0 and type&SUMMON_TYPE_NORMAL~=0 then return true else return f1(sc,type) end
		end
		local f2=Card.GetSummonType
		Card.GetSummonType=function(sc)
			local res=f2(sc)
			if sc:GetFlagEffect(id)>0 then return res|SUMMON_TYPE_NORMAL else return res end
		end
	end
end
function s.costfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function s.spfilter(c,e,tp,lv)
	return c:IsLevelAbove(3) and c:IsRace(RACE_PSYCHO) and not c:IsType(TYPE_TUNER) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return e:IsCostChecked() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,cg:GetClassCount(Card.GetLevel)) end
	local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,cg:GetClassCount(Card.GetLevel))
	local lvt={}
	for tc in aux.Next(tg) do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
	end
	local pc=1
	for i=1,12 do if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg=cg:SelectSubGroup(tp,aux.dlvcheck,false,lv,lv)
	Duel.SendtoGrave(rg,REASON_COST)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	e:SetLabel(#tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.sfilter(c,e,tp,lv)
	return c:IsRace(RACE_PSYCHO) and not c:IsType(TYPE_TUNER) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv):GetFirst()
	if not tc then return end
	if s.spsummon(tc,tp)~=0 then
		if Duel.GetFlagEffect(tp,id)==0 then Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0) else Duel.ResetFlagEffect(tp,id) end
		Duel.RaiseEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0)
	end
end
function s.rcon(con,cost,tg,op)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local le={e:GetHandler():IsHasEffect(id)}
				if #le>0 then
					local v=(le[1]):GetLabelObject()
					local rcon=v:GetCondition() or aux.TRUE
					local rcost=v:GetCost() or aux.TRUE
					local rtg=v:GetTarget() or aux.TRUE
					local rop=v:GetOperation()
					if con(e,tp,eg,ep,ev,re,r,rp) and cost(e,tp,eg,ep,ev,re,r,rp,0) and tg(e,tp,eg,ep,ev,re,r,rp,0,false) and con==rcon and cost==rcost and tg==rtg and ((op and rop and op==rop) or (not op and not rop)) then Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) end
					for _,effect in pairs(le) do effect:Reset() end
				else Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) end
				return con(e,tp,eg,ep,ev,re,r,rp)
			end
end
function s.cfilter(c)
	local se=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	return se and se:IsActivated() and se:GetHandler():IsRace(RACE_PSYCHO)
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function s.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)
	if chk==0 then return g:IsContains(e:GetHandler()) and not g:IsExists(aux.NOT(Card.IsAbleToRemoveAsCost),1,nil) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.filter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not g or g:IsContains(c))
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(s.cfilter,nil)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do sg:AddCard(tc:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT):GetHandler()) end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp,sg) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not tc:IsRelateToEffect(e) or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if s.spsummon(tc,tp)~=0 then
		if Duel.GetFlagEffect(tp,id)==0 then Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0) else Duel.ResetFlagEffect(tp,id) end
		Duel.RaiseEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0)
	end
end
function s.spsummon(tc,tp)
	local reg=Card.RegisterEffect
	tc:RegisterFlagEffect(id,RESET_EVENT+0xec0000,0,1)
	Card.RegisterEffect=function(sc,se,bool)
		if se:GetCode()==EVENT_SUMMON_SUCCESS then
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(0xff)
			e1:SetCode(id)
			e1:SetLabelObject(se)
			e1:SetReset(RESET_CHAIN)
			reg(sc,e1,true)
		elseif se:GetCode()==EVENT_SPSUMMON_SUCCESS then
			local con=se:GetCondition() or aux.TRUE
			local cost=se:GetCost() or aux.TRUE
			local tg=se:GetTarget() or aux.TRUE
			local op=se:GetOperation()
			se:SetCondition(s.rcon(con,cost,tg,op))
		end
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(0xff)
		e2:SetCode(id+500)
		e2:SetLabelObject(se)
		reg(sc,e2,true)
		return reg(sc,se,bool)
	end
	if tc.initial_effect then
		local ini=s.initial_effect
		s.initial_effect=function() end
		if tc:GetFlagEffect(53702700)>0 then
			local le={tc:IsHasEffect(id+500)}
			for _,v in pairs(le) do v:GetLabelObject():Reset() v:Reset() end
		else tc:ReplaceEffect(id,0) end
		s.initial_effect=ini
		tc.initial_effect(tc)
		tc:RegisterFlagEffect(53702700,0,0,0)
	end
	Card.RegisterEffect=reg
	return Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
