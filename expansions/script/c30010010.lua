--超量唤读器
local m = 30010010
local cm = _G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,aux.TRUE,2,2)
	--gain xyz_level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e1:SetTarget(cm.xyz_lv_tg)
	e1:SetValue(cm.xyzlv)
	c:RegisterEffect(e1)
	--xyz SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.xyzcon)
	e2:SetTarget(cm.xyztg)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
	if not cm.check then
		cm.check=50
	end
	--xyzmat SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(46565218,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.cfilter(c)
	return c:IsType(TYPE_XYZ)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and not c:IsCode(m)
end
function cm.xyz_lv_tg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and cm.check==100
end
function cm.xyzlv(e,c,rc)
	return rc:GetRank()
end
function cm.xyzmatfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cm.xyzff(g,rc,oc)
	local mg=Group.__add(g,oc)
	return rc:IsXyzSummonable(mg,#mg,#mg)
end
function cm.xyzfilter(c,mg,oc)
	local flag=false 
	if c:IsAttribute(ATTRIBUTE_DARK) and c:IsRank(12) and c:IsRace(RACE_FIEND) then
		flag=mg:CheckSubGroup(cm.xyzff,11,11,c,oc)
	else
		flag=mg:CheckSubGroup(cm.xyzff,0,#mg,c,oc)
	end
	return flag
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	if chk==0 then
		cm.check=100
		local mg=Duel.GetMatchingGroup(cm.xyzmatfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
		g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,e:GetHandler())
		cm.check=50
		return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	cm.check=100
	local mg=Duel.GetMatchingGroup(cm.xyzmatfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
	g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,e:GetHandler())
	cm.check=50
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:Select(tp,1,1,nil)
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm.check=100
	local mg=Duel.GetMatchingGroup(cm.xyzmatfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm.xyzfilter(tc,mg,c) then
		local tg=Group.CreateGroup()
		local tc_f=tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsRank(12) and tc:IsRace(RACE_FIEND)
		if tc_f then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			tg=mg:SelectSubGroup(tp,cm.xyzff,false,11,11,tc,c)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			tg=mg:SelectSubGroup(tp,cm.xyzff,false,0,#mg,tc,c)
		end
		if #tg>0 then 
			tg:AddCard(c)
			tc:SetMaterial(tg)
			Duel.Overlay(tc,tg)
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
			if tc_f then
				cm[0]=Card.RegisterEffect
				Card.RegisterEffect=function(cc,ce,forced)
					return cm[0](cc,ce,true)
				end
				for sc in aux.Next(tg) do
					tc:CopyEffect(sc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD)
				end
				Card.RegisterEffect=cm[0]
			end 
		end
	end
	cm.check=50
end
function cm.ov(c,tp)
	local xg=Duel.GetOverlayGroup(tp,1,1)
	xg:RemoveCard(c)
	return #xg>0
end
function cm.ck(c)
	local b1=c:IsFacedown() and c:IsLocation(LOCATION_REMOVED)
	local b2=c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
	return c:IsType(TYPE_MONSTER) and not (b1 or b2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup():Filter(cm.ov,nil,tp)
	if chk==0 then return #mg>0 end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=mg:FilterSelect(tp,cm.ov,1,1,nil,tp)
	if #g>0 and Duel.SendtoGrave(g,REASON_COST)>0 then
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
		e:SetLabel(100)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xg=Duel.GetOverlayGroup(tp,1,1)
	if e:GetLabel()~=100 or #xg==0 then return end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=xg:Select(tp,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		local tc=Duel.GetOperatedGroup():Filter(cm.ck,nil):GetFirst()
		if tc and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0  
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--yilong
