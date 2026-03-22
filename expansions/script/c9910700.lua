if QutryYgzw then return end
QutryYgzw = {}

function QutryYgzw.AddSpProcedure(c,inicount)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(QutryYgzw.SpCondition(inicount))
	e1:SetOperation(QutryYgzw.SpOperation(inicount))
	c:RegisterEffect(e1)
end
function QutryYgzw.SpFilter(c,att)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost()
		and not (att and c:IsAttribute(att))
end
function QutryYgzw.SpUseDeckFilter(c,tp,ct)
	return Duel.IsPlayerAffectedByEffect(tp,9910743) and c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (ct<2 or Duel.IsExistingMatchingCard(QutryYgzw.SpFilter,tp,LOCATION_GRAVE,0,ct-1,nil,c:GetAttribute()))
end
function QutryYgzw.SpCondition(inicount)
	return  function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
				local ct=inicount
				if c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsPlayerAffectedByEffect(tp,9910738) then ct=ct-1 end
				local gyg=Duel.GetMatchingGroup(QutryYgzw.SpFilter,tp,LOCATION_GRAVE,0,nil,nil)
				local deckg=Duel.GetMatchingGroup(QutryYgzw.SpUseDeckFilter,tp,LOCATION_DECK,0,nil,tp,ct)
				return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (ct<=0 or #gyg>=ct or #deckg>0)
			end
end
function QutryYgzw.SpOperation(inicount)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local ct=inicount
				if c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsPlayerAffectedByEffect(tp,9910738) then ct=ct-1 end
				if ct==0 then return end
				local att
				local gyg=Duel.GetMatchingGroup(QutryYgzw.SpFilter,tp,LOCATION_GRAVE,0,nil,nil)
				local deckg=Duel.GetMatchingGroup(QutryYgzw.SpUseDeckFilter,tp,LOCATION_DECK,0,nil,tp,ct)
				if #deckg>0 and (#gyg<ct or Duel.SelectYesNo(tp,aux.Stringid(9910700,0))) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local tc=deckg:Select(tp,1,1,nil):GetFirst()
					att=tc:GetAttribute()
					Duel.SendtoGrave(tc,REASON_COST)
					ct=ct-1
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=gyg:FilterSelect(tp,QutryYgzw.SpFilter,ct,ct,nil,att)
				Duel.Remove(sg,POS_FACEUP,REASON_COST)
			end
end
function QutryYgzw.SetFilter(c,e,tp)
	if c:IsType(TYPE_TOKEN) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function QutryYgzw.SetFilter2(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and QutryYgzw.SetFilter(c,e,tp)
end
function QutryYgzw.Set(c,e,tp)
	local op=e:GetHandlerPlayer()
	if not Duel.MoveToField(c,op,tp,LOCATION_SZONE,POS_FACEDOWN,true) then return false end
	Duel.ConfirmCards(1-tp,c)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,op,op,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	return true
end
function QutryYgzw.Set2(g,e,tp)
	local op=e:GetHandlerPlayer()
	local og=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,op,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
			og:AddCard(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	if #og>1 then Duel.ShuffleSetCard(og) end
	if #og>0 then Duel.RaiseEvent(og,EVENT_SSET,e,REASON_EFFECT,op,op,0) end
	return og
end
function QutryYgzw.AddTgFlag(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(QutryYgzw.TgOperation())
	c:RegisterEffect(e1)
end
function QutryYgzw.TgOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsPreviousLocation(LOCATION_ONFIELD) then
					c:RegisterFlagEffect(9910700,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910700,1))
				end
			end
end
function QutryYgzw.AddLinkProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(QutryYgzw.LinkCondition(aux.FilterBoolFunction(Card.IsLinkSetCard,0xc950),2,99))
	e1:SetTarget(QutryYgzw.LinkTarget(aux.FilterBoolFunction(Card.IsLinkSetCard,0xc950),2,99))
	e1:SetOperation(QutryYgzw.LinkOperation(aux.FilterBoolFunction(Card.IsLinkSetCard,0xc950),2,99))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function QutryYgzw.LConditionFilter(c,f,lc)
	return (((c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc))) and (not f or f(c))
end
function QutryYgzw.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(QutryYgzw.LConditionFilter,tp,LOCATION_MZONE+LOCATION_DECK,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function QutryYgzw.LCheckGoal(sg,tp,lc,gf,lmat)
	local ct=1
	if Duel.IsPlayerAffectedByEffect(tp,9911762) then ct=2 end
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg)) and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp) and (not lmat or sg:IsContains(lmat)) and not sg:IsExists(Card.IsLocation,ct,nil,LOCATION_DECK)
end
function QutryYgzw.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(QutryYgzw.LConditionFilter,nil,f,c)
				else
					mg=QutryYgzw.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not QutryYgzw.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				local limit=99
				if c:IsLink(2) then limit=2 end
				return mg:CheckSubGroup(QutryYgzw.LCheckGoal,2,limit,tp,c,gf,lmat)
			end
end
function QutryYgzw.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(QutryYgzw.LConditionFilter,nil,f,c)
				else
					mg=QutryYgzw.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not QutryYgzw.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local limit=99
				if c:IsLink(2) then limit=2 end
				local sg=mg:SelectSubGroup(tp,QutryYgzw.LCheckGoal,cancel,2,limit,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function QutryYgzw.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				aux.LExtraMaterialCount(g,c,tp)
				g1=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
				g:Sub(g1)
				Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
