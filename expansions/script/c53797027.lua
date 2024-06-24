local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	if not s.global_check then
		s.global_check=true
		s[0]={}
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	if Duel.SendtoGrave(c,REASON_COST)~=0 and c:IsLocation(LOCATION_GRAVE) then c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
end
function s.filter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,tc)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)==0 then return end
	local code1,code2=tc:GetOriginalCode(),tc:GetOriginalCodeRule()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.aclimit)
	e1:SetLabel(code2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabel(code2)
	e2:SetValue(s.mtval)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetLabel(code1,code2,c:GetFieldID())
	e3:SetOperation(s.adjust)
	Duel.RegisterEffect(e3,tp)
	Duel.AdjustAll()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_GRAVE)
	e4:SetLabel(code1,code2)
	e4:SetOperation(s.rstop)
	Duel.RegisterEffect(e4,tp)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function s.mtval(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.adjust(e,_,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local code1,code2,fid=e:GetLabel()
	if fid~=c:GetFieldID() then
		e:Reset()
		return
	end
	local mtf,mts=_G["c"..code2],_G["c"..code1]
	local f=(mtf.mat_group_check or aux.TRUE)
	if not s[0][code2] then s[0][code2]=f end
	mtf.mat_group_check=function(g,tp)
		return f(g,tp) and (g:IsContains(c) or c:IsControler(1-tp))
	end
	if math.abs(code1-code2)>=10 then
		if not mts then Duel.CreateToken(0,code1) end
		local f2=(mts.mat_group_check or aux.TRUE)
		if not s[0][code1] then s[0][code1]=f2 end
		mts.mat_group_check=function(g,tp)
			return f2(g,tp) and (g:IsContains(c) or c:IsControler(1-tp))
		end
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if not eg:IsContains(c) then return end
	local code1,code2=e:GetLabel()
	local mtf,mts=_G["c"..code2],_G["c"..code1]
	mtf.mat_group_check=s[0][code2]
	if math.abs(code1-code2)>=10 then mts.mat_group_check=s[0][code1] end
	Duel.AdjustAll()
	e:Reset()
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	eg:KeepAlive()
	e:GetLabelObject():SetLabelObject(eg)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RITUAL)
end
function s.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_RELEASE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if not g or #g==0 then return false end
	local mat=Group.CreateGroup()
	for tc in aux.Next(g) do mat:Merge(tc:GetMaterial()) end
	if chk==0 then return true end
	Duel.SetTargetCard(g)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=mat:Filter(s.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,math.min(ft,#tg),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 or Duel.Destroy(g,REASON_EFFECT)<=0 then return end
	local mat=Group.CreateGroup()
	for tc in aux.Next(g) do mat:Merge(tc:GetMaterial()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=mat:Filter(s.spfilter,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else g=tg end
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
