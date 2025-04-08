--奇术尊者 罗森克鲁兹之心
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.SynMixCondition(aux.Tuner(Card.IsSetCard,0xc620),nil,nil,aux.NonTuner(nil),1,99,gc))
	e0:SetTarget(cm.SynMixTarget(aux.Tuner(Card.IsSetCard,0xc620),nil,nil,aux.NonTuner(nil),1,99,gc))
	e0:SetOperation(cm.SynMixOperation(aux.Tuner(Card.IsSetCard,0xc620),nil,nil,aux.NonTuner(nil),1,99,gc))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--level
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	e33:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e33:SetCountLimit(1)
	e33:SetCondition(cm.lvcon)
	e33:SetOperation(cm.lvop)
	c:RegisterEffect(e33)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(e33)
	e1:SetOperation(cm.bkop)
	c:RegisterEffect(e1)
	
	
end
function cm.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,c,smat,mg1,min,max)
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
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				return mg:IsExists(cm.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
			end
end
function cm.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local g=Group.CreateGroup()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=aux.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c1=mg:FilterSelect(tp,cm.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):GetFirst()
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c2=mg:FilterSelect(tp,cm.SynMixFilter2,1,1,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):GetFirst()
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						local c3=mg:FilterSelect(tp,cm.SynMixFilter3,1,1,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):GetFirst()
						g:AddCard(c3)
					end
				end
				local g4=Group.CreateGroup()
				local i=0
				--while i==0 do
					local mg2=mg:Clone()
					mg2=mg2:Filter(f4,g,c)
					local cg=mg2:Filter(cm.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc,mgchk)
					--if cg:GetCount()==0 then break end
					local minct=1
					if g4:GetCount()~=0 then minct=0 end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local tg=cg:Select(tp,minct,99,nil)
					--if tg:GetCount()==0 then break end
					g4:Merge(tg)
				--end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.SynMixOperation(f1,f2,f3,f4,minct,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
			end
end
function cm.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	return (not f1 or f1(c,syncard)) and mg:IsExists(cm.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function cm.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc,mgchk)
	if f2 then
		return f2(c,syncard,c1) and mg:IsExists(cm.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc,mgchk)
	else
		return mg:IsExists(cm.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc,mgchk)
	end
end
function cm.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc,mgchk)
	if f3 then
		return f3(c,syncard,c1,c2) and mg:IsExists(cm.SynMixFilter4,1,Group.FromCards(c1,c2,c),f4,minc,maxc,syncard,mg,smat,c1,c2,c,gc,mgchk)
	else
		return mg:IsExists(cm.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc,mgchk)
	end
end
function cm.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard)
	else
		mg:Sub(sg)
	end
	return cm.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function cm.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc==0 and cm.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk) then return true end
	if maxc==0 then return false end
	return mg:IsExists(cm.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk)
end
function cm.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
		or (ct<maxc and mg:IsExists(cm.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 and not mgchk then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end

function cm.rmfil(c,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(lv-1) and c:IsAbleToRemove()
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) --and e:GetHandler():GetFlagEffect(m)~=0
end
function cm.ttlv(c)
	return c:GetOriginalLevel()
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local xlv=g:GetSum(cm.ttlv)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(xlv)
	c:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(cm.rmfil,tp,LOCATION_EXTRA,0,1,nil,xlv) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local rg=Duel.GetMatchingGroup(cm.rmfil,tp,LOCATION_EXTRA,0,nil,xlv):Select(tp,1,1,nil)
		if rg and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) then
			local rmvg=Duel.GetOperatedGroup()
			rmvg:KeepAlive()
			e:SetLabelObject(rmvg)
			local code=rmvg:GetFirst():GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
		end
	end
end

function cm.mgfilter(c,tp,sync)
	return c:IsControler(tp) and not c:IsFacedown()
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsAbleToHand()
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local bg=e:GetLabelObject():GetLabelObject()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	local a=#Duel.GetOperatedGroup()
	Duel.SendtoDeck(bg,nil,2,REASON_EFFECT)
	local b=#Duel.GetOperatedGroup()
	local mg=e:GetHandler():GetMaterial()
	if a~=0 and b~=0 and #mg~=0 and mg:FilterCount(aux.NecroValleyFilter(cm.mgfilter),nil,tp,e:GetHandler())==#mg and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		local mc=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(mc,nil,REASON_EFFECT)
	end
end